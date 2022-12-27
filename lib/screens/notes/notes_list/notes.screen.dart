import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/screens/notes/notes_list/widgets/expansion_note.widget.dart';
import 'package:note_app/screens/notes/notes_list/widgets/get_notes.dart';
import 'package:note_app/screens/notes/notes_list/widgets/pop_up_menu_sort.dart';
import 'package:note_app/screens/notes/notes_list/widgets/search_notes_delegate.dart';
import 'package:provider/provider.dart';

import '../../../providers/note.provider.dart';
import '../../../providers/note_screen.provider.dart';
import '../../../resources/colors/colors.dart';
import '../../../resources/constants/asset_path.dart';
import '../../../resources/fonts/enum_text_styles.dart';
import '../../../resources/fonts/text_styles.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/show_snack_bar.dart';
import '../../../widgets/bar/app_bar.dart';
import '../../../widgets/bar/bottom_bar.dart';
import '../../../widgets/buttons/button_app_bar.dart';
import '../type.dart';
import 'move_notes.screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({
    super.key,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late NoteProvider noteProvider;
  late NoteScreenProvider noteScreenProvider;
  late NoteScreenProvider noteScreenProviderValue;

  String? folderId;
  late Future<void>? _getItems;

  @override
  void initState() {
    noteProvider = Provider.of<NoteProvider>(context, listen: false);
    noteScreenProvider =
        Provider.of<NoteScreenProvider>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    noteScreenProvider.changeReloadNotNotify(true);
    super.dispose();
  }

  void doAllSelection() {
    noteScreenProvider.changeReload(false);
    for (var note in noteProvider.getNotes) {
      noteScreenProvider.addSelection(note);
    }
  }

  void deleteNotesSelection() {
    for (var noteSelected in noteScreenProvider.getSelectedItemSet) {
      noteProvider.deleteNote(folderId!, noteSelected.noteId);
    }

    noteScreenProvider.finishSelectionMode();

    showSnackBarSuccess(context, "Deleted successfully");
  }

  bool isSelectionAll() =>
      noteScreenProvider.getSelectedItemSet.length !=
      noteProvider.getNotes.length;

  Future<void> handleMoveNotesSelection() async {
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SelectFolderToMoveNotes(
              folderIdException: folderId!,
            ),
          ),
        )
        .then((value) async {
          if (value != null) {
            for (var noteSelected in noteScreenProvider.getSelectedItemSet) {
              noteProvider.createNewNoteForMove(
                  ownerFolderId: value.folderId, note: noteSelected);
              if (FirebaseAuth.instance.currentUser != null) {
                noteProvider.deleteNote(folderId!, noteSelected.noteId);
              }
              log("move");
            }
            return true;
          } else {
            return false;
          }
        })
        .then((value) => {
              if (value)
                {
                  Future.delayed(Duration.zero, () {
                    noteScreenProvider.finishSelectionMode();
                    showSnackBarSuccess(context, "Moved");
                  })
                }
              else
                {
                  Future.delayed(Duration.zero, () {
                    noteScreenProvider.clearAndCancelSelectionMode();
                    showSnackBarInfo(context, "Canceled");
                  })
                }
            })
        .catchError((e) {
          Future.delayed(Duration.zero, () {
            noteScreenProvider.clearAndCancelSelectionMode();
            showSnackBarError(context, "Something went wrong");
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    noteScreenProviderValue = Provider.of(context);

    if (folderId == null) {
      final argruments = (ModalRoute.of(context)!.settings.arguments ??
          <String, dynamic>{}) as Map;

      folderId = argruments["folderId"];
    }

    _getItems = noteScreenProviderValue.getReload
        ? noteProvider.fetchAllNotes(folderId!)
        : null;

    return FutureBuilder(
      future: _getItems,
      builder: ((context, snapshot) {
        return Scaffold(
          bottomNavigationBar: BottomBarCustom(
            title: noteScreenProvider.getIsMultiSelectionMode
                ? "${noteScreenProvider.getSelectedItemSet.length} notes selected"
                : "${noteProvider.getNotes.length} notes",
            isLeft: noteScreenProvider.getIsMultiSelectionMode,
            actionLeft: noteScreenProvider.getIsMultiSelectionMode
                ? () {
                    handleMoveNotesSelection();
                  }
                : null,
            textLeft:
                noteScreenProvider.getIsMultiSelectionMode ? "Move" : null,
            textRight:
                noteScreenProvider.getIsMultiSelectionMode ? "Delete" : "Add",
            actionRight: noteScreenProvider.getIsMultiSelectionMode
                ? () {
                    deleteNotesSelection();
                  }
                : () {
                    Navigator.of(context).pushNamed(Routes.editNote,
                        arguments: {
                          "type": NoteType.newNote,
                          "folderId": folderId
                        });
                  },
          ),
          appBar: CustomAppbar(
            title: "All notes",
            handleBackBtn: () {
              noteProvider.setDefaultValue();
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pop();
              });
            },
            isBackBtn: !noteScreenProvider.getIsMultiSelectionMode,
            isSelectionMode: noteScreenProvider.getIsMultiSelectionMode,
            isTitle: !noteScreenProvider.getIsMultiSelectionMode,
            leadingButton: ButtonAppbar(
              backgroundColor: AppColors.brightRed,
              foregroundColor: AppColors.red,
              nameBtn: isSelectionAll() ? "Select All" : "Deselect All",
              styleBtnText: isSelectionAll()
                  ? AppTextStyles.subtitile[TextWeights.semibold]!
                      .copyWith(color: AppColors.red)
                  : AppTextStyles.body2[TextWeights.bold]!
                      .copyWith(color: AppColors.red),
              onPress: () {
                isSelectionAll()
                    ? doAllSelection()
                    : noteScreenProvider.clearMultiSelection();
              },
            ),
            extraActions: noteScreenProvider.getIsMultiSelectionMode
                ? [
                    ButtonAppbar(
                      backgroundColor: AppColors.brightGreen,
                      foregroundColor: AppColors.green,
                      nameBtn: "Cancel",
                      onPress: () {
                        noteScreenProvider.clearAndCancelSelectionMode();
                        showSnackBarInfo(context, "Canceled");
                      },
                    )
                  ]
                : [
                    InkWell(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: BuildSearchNotesDelegate(
                              folderId: folderId!,
                              notes: noteProvider.getNotes),
                          useRootNavigator: false,
                        );
                      },
                      child: const Icon(
                        Icons.search,
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        showPopupMenuSort(context, details.globalPosition);
                      },
                      child: Image.asset(
                        AssetPaths.sortIcon,
                        width: 28.w,
                        height: 28.w,
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    )
                  ],
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: ListView(
                  children: noteProvider.getLengthPins > 0
                      ? [
                          ExpansionNoteWidget(
                            childs: getChildrenNote(
                                context, PinType.pin, folderId!),
                            title: "Pin",
                          ),
                          SizedBox(
                            height: 36.h,
                          ),
                          ExpansionNoteWidget(
                              childs: getChildrenNote(
                                  context, PinType.unpin, folderId!),
                              title: "Notes")
                        ]
                      : getChildrenNote(context, PinType.all, folderId!)),
            ),
          ),
        );
      }),
    );
  }
}

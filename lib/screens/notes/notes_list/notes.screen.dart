import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focused_menu/modals.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/screens/notes/notes_list/widgets/expansion_tile.dart';
import 'package:note_app/screens/notes/notes_list/widgets/focus_menu.widget.dart';
import 'package:note_app/screens/notes/notes_list/widgets/note.widget.dart';
import 'package:provider/provider.dart';

import '../../../models/note.dart';
import '../../../providers/note.provider.dart';
import '../../../resources/colors/colors.dart';
import '../../../resources/fonts/enum_text_styles.dart';
import '../../../resources/fonts/text_styles.dart';
import '../../../utils/routes/routes.dart';
import '../../../widgets/bar/app_bar.dart';
import '../../../widgets/bar/bottom_bar.dart';
import '../type.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({
    super.key,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late NoteProvider noteProvider;
  String? folderId;
  bool isExpanded = true;
  late Future<void>? _getItems;
  bool isMultiSelectionEnabled = false;
  bool isReload = true;

  @override
  void initState() {
    noteProvider = Provider.of<NoteProvider>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String?> _showTextInputDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('New note'),
  //           content: TextField(
  //             controller: _textFieldController,
  //             decoration: const InputDecoration(hintText: "Title note"),
  //           ),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               child: const Text("Cancel"),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //             ElevatedButton(
  //               child: const Text('OK'),
  //               onPressed: () =>
  //                   Navigator.pop(context, _textFieldController.text),
  //             ),
  //           ],
  //         );
  //       });
  // }

  HashSet<Note> selectedItemsSet = HashSet();
  void doMultiSelection(Note note) {
    if (isMultiSelectionEnabled) {
      if (selectedItemsSet.contains(note)) {
        selectedItemsSet.remove(note);
      } else {
        selectedItemsSet.add(note);
      }
      setState(() {
        isReload = false;
      });
    } else {
      //Other logic
    }
  }

  void doAllSelection() {
    setState(() {
      for (var note in noteProvider.getNotes) {
        selectedItemsSet.add(note);
      }
      isReload = false;
    });
  }

  void clearAllSelection() {
    setState(() {
      selectedItemsSet.clear();
      isReload = false;
    });
  }

  void deleteNotesSelection() {
    for (var noteSelected in selectedItemsSet) {
      noteProvider.deleteNote(folderId!, noteSelected.noteId);
    }

    setState(() {
      selectedItemsSet.clear();
      isMultiSelectionEnabled = false;
      isReload = true;
    });
  }

  void pinNote(Note note) {
    setState(() {
      note.isPin = !note.isPin;
      noteProvider.updateNote(folderId!, note);
      isReload = true;
    });
  }

  void deleteNote(Note note) {
    noteProvider.deleteNote(folderId!, note.noteId);

    setState(() {
      selectedItemsSet.clear();
      isMultiSelectionEnabled = false;
      isReload = true;
    });
  }

  bool isSelectionAll() =>
      selectedItemsSet.length != noteProvider.getNotes.length;

  Widget noteChild(Note note, bool isDivider) {
    return isMultiSelectionEnabled
        ? Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  child: Icon(
                    selectedItemsSet.contains(note)
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 30.w,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50.w,
                  child: NoteListTileWidget(
                    isDivider: isDivider,
                    note: note,
                    onTap: () {
                      doMultiSelection(note);
                      // Navigator.of(context).pushNamed(
                      //   Routes.editNote,
                      //   arguments: {
                      //     "type": NoteType.editNote,
                      //     "folderId": folderId,
                      //     "note": note,
                      //   },
                      // );
                    },
                  ),
                ),
              ],
            ),
          )
        : Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    pinNote(note);
                  },
                  backgroundColor: AppColors.yellowGold,
                  icon: note.isPin
                      ? Icons.usb_off_rounded
                      : Icons.push_pin_outlined,
                  label: note.isPin ? "Unpin" : "Pin",
                )
              ],
            ),
            endActionPane: ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Colors.green,
                icon: Icons.folder,
                label: "Move",
              ),
              SlidableAction(
                onPressed: (context) {
                  deleteNote(note);
                },
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: "Delete",
              )
            ]),
            child: FocusedMenuHolder(
              blurBackgroundColor: Colors.black54,
              menuOffset: 10,
              blurSize: 5.0,
              duration: const Duration(milliseconds: 100),
              menuItems: [
                FocusedMenuItem(
                    title: note.isPin ? const Text("Unpin") : const Text("Pin"),
                    trailingIcon: note.isPin
                        ? const Icon(Icons.usb_off_rounded)
                        : const Icon(Icons.push_pin_outlined),
                    onPressed: () {
                      pinNote(note);
                    }),
                FocusedMenuItem(
                    title: const Text("Lock"),
                    trailingIcon: const Icon(Icons.lock),
                    onPressed: () {
                      log("share");
                    }),
                FocusedMenuItem(
                  title: const Text("Move"),
                  trailingIcon: const Icon(Icons.drive_folder_upload_rounded),
                  onPressed: () {},
                ),
                FocusedMenuItem(
                  title: const Text("Select Notes"),
                  trailingIcon: const Icon(Icons.check_circle),
                  onPressed: () {
                    setState(() {
                      isMultiSelectionEnabled = true;
                      isReload = false;
                    });
                  },
                ),
                // FocusedMenuItem(
                //   title: const Text("Share"),
                //   trailingIcon: const Icon(Icons.share),
                //   onPressed: () {},
                // ),
                FocusedMenuItem(
                  title: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  trailingIcon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    deleteNote(note);
                  },
                ),
              ],
              onPressed: () {},
              child: NoteListTileWidget(
                isDivider: isDivider,
                note: note,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.editNote,
                    arguments: {
                      "type": NoteType.editNote,
                      "folderId": folderId,
                      "note": note,
                    },
                  );
                },
              ),
            ),
          );
  }

  List<Widget> _getChildren(PinType type) {
    NoteProvider noteProviderValue = Provider.of<NoteProvider>(context);
    List<Widget> results = [];
    switch (type) {
      case PinType.all:
        {
          results =
              List<Widget>.generate(noteProviderValue.getNotes.length, (index) {
            bool isDivider = true;
            Note note = noteProvider.getNotes[index];
            if (index == noteProvider.getNotes.length - 1) {
              isDivider = false;
            }
            return noteChild(note, isDivider);
          });
          break;
        }
      case PinType.pin:
        {
          results = List<Widget>.generate(noteProvider.getLengthPins, (index) {
            bool isDivider = true;
            Note note = noteProvider.getPinNotes[index];
            if (index == noteProvider.getLengthPins - 1) {
              isDivider = false;
            }
            return noteChild(note, isDivider);
          });
          break;
        }
      case PinType.unpin:
        {
          results =
              List<Widget>.generate(noteProvider.getLengthUnPins, (index) {
            bool isDivider = true;
            Note note = noteProvider.getUnPinNotes[index];
            if (index == noteProvider.getLengthUnPins - 1) {
              isDivider = false;
            }
            return noteChild(note, isDivider);
          });
          break;
        }
    }
    return results;
  }

  Widget iconExpansionTile() => isExpanded
      ? const Icon(Icons.keyboard_arrow_down)
      : const Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    if (folderId == null) {
      final argruments = (ModalRoute.of(context)!.settings.arguments ??
          <String, dynamic>{}) as Map;

      folderId = argruments["folderId"];
    }

    _getItems = isReload ? noteProvider.fetchAllNotes(folderId!) : null;

    return FutureBuilder(
      future: _getItems,
      builder: ((context, snapshot) {
        return Scaffold(
          bottomNavigationBar: BottomBarCustom(
            title: isMultiSelectionEnabled
                ? "${selectedItemsSet.length} notes selected"
                : "${noteProvider.getNotes.length} notes",
            isLeft: isMultiSelectionEnabled,
            actionLeft: isMultiSelectionEnabled ? () {} : null,
            textLeft: isMultiSelectionEnabled ? "Move" : null,
            textRight: isMultiSelectionEnabled ? "Delete" : "Add",
            actionRight: isMultiSelectionEnabled
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
            handleBackBtn: () => Navigator.of(context).pop(),
            isBackBtn: !isMultiSelectionEnabled,
            isSelectionMode: isMultiSelectionEnabled,
            isTitle: !isMultiSelectionEnabled,
            leadingButton: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: ElevatedButton(
                onPressed: () {
                  isSelectionAll() ? doAllSelection() : clearAllSelection();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.brightRed,
                  foregroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r), // <-- Radius
                  ),
                ),
                child: Text(
                  isSelectionAll() ? 'Select All' : 'Deselect All',
                  style: isSelectionAll()
                      ? AppTextStyles.subtitile[TextWeights.semibold]!
                          .copyWith(color: AppColors.red)
                      : AppTextStyles.body2[TextWeights.bold]!
                          .copyWith(color: AppColors.red),
                ),
              ),
            ),
            // leadingButton: const SmallButton(
            //   isOutlined: false,
            //   textBtn: "Select All",

            // ),
            extraActions: isMultiSelectionEnabled
                ? [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isMultiSelectionEnabled = false;
                            clearAllSelection();
                            isReload = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.brightGreen,
                          foregroundColor: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.r), // <-- Radius
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.subtitile[TextWeights.semibold]!
                              .copyWith(color: AppColors.green),
                        ),
                      ),
                    )
                  ]
                : [
                    InkWell(
                      onTap: () {
                        log("chua xu ly");
                      },
                      child: const Icon(
                        Icons.search,
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    InkWell(
                      onTap: () {
                        log("chua xu ly");
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
                          ExpansionTileCustom(
                            initiallyExpanded: true,
                            iconColor: AppColors.gray[80],
                            collapsedIconColor: AppColors.gray[80],
                            collapsedTextColor: AppColors.gray[80],
                            textColor: AppColors.gray[80],
                            title: Text(
                              "Pin",
                              style: AppTextStyles.h5[TextWeights.extrabold],
                            ),
                            onExpansionChanged: ((value) {}),
                            children: _getChildren(PinType.pin),
                          ),
                          SizedBox(
                            height: 36.h,
                          ),
                          ExpansionTileCustom(
                            initiallyExpanded: true,
                            iconColor: AppColors.gray[80],
                            collapsedIconColor: AppColors.gray[80],
                            collapsedTextColor: AppColors.gray[80],
                            textColor: AppColors.gray[80],
                            title: Text(
                              "Notes",
                              style: AppTextStyles.h5[TextWeights.extrabold],
                            ),
                            onExpansionChanged: ((value) {}),
                            children: _getChildren(PinType.unpin),
                          )
                        ]
                      : _getChildren(PinType.all)),
            ),
          ),
          // floatingActionButton: Padding(
          //   padding: EdgeInsets.only(bottom: 104.h, right: 20.w),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(Routes.editNote, arguments: {
          //         "type": NoteType.newNote,
          //         "folderId": folderId
          //       });
          //     },
          //     child: Image.asset(AssetPaths.addFolder),
          //   ),
          // ),
        );
      }),
    );
  }
}

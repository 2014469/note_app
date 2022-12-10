import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/modals.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/screens/notes/notes_list/widgets/note.widget.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../providers/note.provider.dart';
import '../../../utils/routes/routes.dart';
import '../type.dart';
import 'widgets/focus_menu.widget.dart';

// Enum Actions  {pin, delete, move};

class NotesScreen extends StatefulWidget {
  const NotesScreen({
    super.key,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late NoteProvider noteProvider;

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

  @override
  Widget build(BuildContext context) {
    final argruments = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;

    final folderId = argruments["folderId"];

    NoteProvider noteProviderValue = Provider.of<NoteProvider>(context);

    return FutureBuilder(
      future: noteProvider.fetchAllNotes(folderId),
      builder: ((context, snapshot) {
        return Scaffold(
          appBar: CustomAppbar(
            title: "All notes",
            handleBackBtn: () => Navigator.of(context).pop(),
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: noteProviderValue.getNotes.length,
                itemBuilder: (context, index) {
                  Note note = noteProviderValue.getNotes[index];

                  return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: AppColors.yellowGold,
                            icon: Icons.share,
                            label: "Pin",
                          )
                        ],
                      ),
                      endActionPane:
                          ActionPane(motion: const BehindMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.green,
                          icon: Icons.folder,
                          label: "Move",
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            noteProvider.deleteNote(folderId, note.noteId);
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
                              title: const Text("Pin"),
                              trailingIcon: const Icon(Icons.push_pin_outlined),
                              onPressed: () {
                                log("Open");
                              }),
                          FocusedMenuItem(
                              title: const Text("Lock"),
                              trailingIcon: const Icon(Icons.lock),
                              onPressed: () {
                                log("share");
                              }),
                          FocusedMenuItem(
                            title: const Text("Move"),
                            trailingIcon:
                                const Icon(Icons.drive_folder_upload_rounded),
                            onPressed: () {},
                          ),
                          FocusedMenuItem(
                            title: const Text("Select Notes"),
                            trailingIcon: const Icon(Icons.check_circle),
                            onPressed: () {},
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
                              log("Delete");
                              noteProvider.deleteNote(folderId, note.noteId);
                            },
                          ),
                        ],
                        onPressed: () {},
                        child: NoteListTileWidget(
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
                      ));
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1.h,
                    thickness: 1.h,
                    indent: 88.w,
                  );
                },
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 104.h, right: 20.w),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.editNote, arguments: {
                  "type": NoteType.newNote,
                  "folderId": folderId
                });
              },
              child: Image.asset(AssetPaths.addFolder),
            ),
          ),
        );
      }),
    );
  }
}

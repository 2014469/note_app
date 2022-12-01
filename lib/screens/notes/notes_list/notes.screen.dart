import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: ListView.separated(
                itemCount: noteProviderValue.getNotes.length,
                itemBuilder: (context, index) {
                  Note note = noteProviderValue.getNotes[index];

                  return InkWell(
                    onTap: () {},
                    child: Slidable(
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
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: "Delete",
                          )
                        ]),
                        child: NoteListTileWidget(
                          note: note,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Routes.editNote, arguments: {
                              "type": NoteType.editNote,
                              "folderId": folderId,
                              "note": note,
                            });
                          },
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  //<-- SEE HERE
                  return Divider(
                    thickness: 1.h,
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

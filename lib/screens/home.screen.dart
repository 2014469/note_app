import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/models/folder_note.dart';
import 'package:note_app/models/folders.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/notes.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/screens/folders/folder.widget.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/cloud/folder/folder_storage_firebase.dart';
import 'package:note_app/services/cloud/note/firebase_note_storage.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/utils/show_snack_bar.dart';

import 'package:note_app/screens/loading.screen.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/avatar/avatar_appbar.dart';
import 'package:note_app/widgets/search/search_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthUser user = AuthUser();
  @override
  void initState() {
    super.initState();
    Folders.folders = [];
  }

  @override
  void dispose() {
    super.dispose();
    Folders.folders = [];
    Notes.notes = [];
  }

  void handleCreateNewFolder() async {
    Folder newFolder = await FolderFirebaseStorage()
        .createNewFolder(ownerUserId: user.uID!, nameFolder: "Hello world");

    newFolder.printInfo();
  }

  void handleCreateNewNote() async {
    Note newFolder = await NoteFirebaseStorage().createNewNote(
        ownerUserId: user.uID!,
        ownerFolderId: "e6e3e060-63ce-11ed-ab00-8fcb546f319b",
        titleNote: "Hello world",
        bodyNote: "");

    newFolder.printInfo();
  }

  void handleGetAllNotes(String idFolder) async {
    try {
      await NoteFirebaseStorage()
          .allNotes(ownerUserId: user.uID!, folderOwnerId: idFolder);
    } catch (e) {
      showSnackBarError(context, e.toString());
    }
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushNamed(Routes.notes);
    });
  }

  void handleGetAllFolders() async {}

  final _textFieldController = TextEditingController();

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New folder'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Name folder"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () =>
                    Navigator.pop(context, _textFieldController.text),
              ),
            ],
          );
        });
  }

  void onSelectPopUpMenu(BuildContext context, int item) {
    switch (item) {
      case 0:
        {
          Navigator.of(context).pushNamed(Routes.infoUser, arguments: user);
          break;
        }
      case 1:
        {
          showSnackBarInfo(context, 'Logout account!');
          context.read<AuthService>().logOUt();
          break;
        }
      case 2:
        {
          showSnackBarInfo(context, 'Deleting account!');
          context.read<AuthService>().deleteAccount();
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthUser?>(
      future: context.read<AuthService>().currentUser,
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (data != null) {
          user = data;
          Future.delayed(Duration.zero, () {
            // showSnackBarSuccess(context, "Login success");
          });
          return FutureBuilder(
            future: FolderFirebaseStorage().allFolders(ownerUserId: user.uID!),
            builder: (context, snapshot) {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: CustomAppbar(
                  isBackBtn: false,
                  handleBackBtn: (() {}),
                  extraActions: <Widget>[
                    PopupMenuButton<int>(
                      icon: AvatarAppbarWidget(
                        urlPhoto: user.photoUrl!,
                      ),
                      onSelected: (value) {
                        onSelectPopUpMenu(context, value);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 0,
                          child: Text("Your profile"),
                        ),
                        const PopupMenuItem(
                          value: 1,
                          child: Text("Logout"),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Text("Delete account"),
                        ),
                      ],
                    ),
                  ],
                  title: "UniNotes",
                ),
                body: SafeArea(
                    child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(children: [
                    SearchBar(controller: _textFieldController,),
                    Expanded(
                      child: GridView.builder(
                          itemCount: Folders.folders.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            Folder folder = Folders.folders[index];
                            return FolderWidget(
                              folder: folder,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.notes, arguments: {
                                "userId": user.uID,
                                "folderId": folder.folderId
                              }),
                              onTapSetting: () {},
                            );
                          }),
                    ),
                  ]),
                )),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 104.h, right: 20.w),
                  child: FloatingActionButton(
                    onPressed: () async {
                      String? a = await _showTextInputDialog(context);

                      if (a != null) {
                        Folder newFolder = await FolderFirebaseStorage()
                            .createNewFolder(
                                ownerUserId: user.uID!, nameFolder: a);

                        Folders.folders.add(newFolder);
                        setState(() {
                          _textFieldController.text = "";
                        });

                        // Future.delayed(const Duration(seconds: 1), () {
                        //   context.read<Folders>().addFolder(newFolder);
                        // });
                      }
                    },
                    child: Image.asset(AssetPaths.addFolder),
                  ),
                ),
              );
            },
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}

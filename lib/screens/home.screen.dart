import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/models/folder_note.dart';
import 'package:note_app/models/folders.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/notes.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/cloud/folder/folder_storage_firebase.dart';
import 'package:note_app/services/cloud/note/firebase_note_storage.dart';
import 'package:note_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

import '../utils/customLog/debug_log.dart';
import '../widgets/app_bar.dart';

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

  void handleGetAllNotes() async {
    await NoteFirebaseStorage().allNotes(
        ownerUserId: user.uID!,
        folderOwnerId: "e6e3e060-63ce-11ed-ab00-8fcb546f319b");
    DebugLog.myLog("HELLO WORLD");
    DebugLog.myLog(Notes.notes.length.toString());
    for (var note in Notes.notes) {
      DebugLog.myLog("______________________________________________________");
      note.printInfo();
      DebugLog.myLog("______________________________________________________");
    }
  }

  void handleGetAllFolders() async {
    await FolderFirebaseStorage().allFolders(ownerUserId: user.uID!);
    DebugLog.myLog("HELLO WORLD");
    DebugLog.myLog(Folders.folders.length.toString());
    for (var folder in Folders.folders) {
      DebugLog.myLog("______________________________________________________");
      folder.printInfo();
      DebugLog.myLog("______________________________________________________");
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
            showSnackBarSuccess(context, "Login success");
          });
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppbar(
              handleBackBtn: (() {
                DebugLog.myLog("Backbtn");
              }),
              extraActions: const <Widget>[],
              title: "All Notes",
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Text("Email: ${user.email}"),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("Username: ${user.displayName}"),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Image.network(user.photoUrl!),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("UID: ${user.uID}"),
                  // const Center(
                  //   child: Text("Home screen! Logged in"),
                  // ),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      showSnackBarInfo(context, 'Logout account!');
                      context.read<AuthService>().logOUt();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                      ),
                    ),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showSnackBarInfo(context, 'Deleting account!');
                      context.read<AuthService>().deleteAccount();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                      ),
                    ),
                    child: const Text(
                      "Delete account",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  SizedBox(
                    height: 16.h,
                  ),

                  ElevatedButton(
                    onPressed: handleCreateNewFolder,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                      ),
                    ),
                    child: const Text(
                      "Create new folder",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  ElevatedButton(
                    onPressed: handleGetAllFolders,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                      ),
                    ),
                    child: const Text(
                      "Get all folder",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),

                  ElevatedButton(
                    onPressed: handleCreateNewNote,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                      ),
                    ),
                    child: const Text(
                      "Create new notes",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  ElevatedButton(
                    onPressed: handleGetAllNotes,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 2.5, 50),
                      ),
                    ),
                    child: const Text(
                      "Get all notes",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: SafeArea(
                child: Center(
              child: Text("Loading"),
            )),
          );
        }
        // todo: setter display name
        // user.updateDisplayName("long");
      },
    );
  }
}

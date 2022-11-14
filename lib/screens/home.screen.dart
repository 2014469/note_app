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
import 'package:note_app/utils/show_snack_bar.dart';

import 'package:note_app/screens/loading.screen.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:provider/provider.dart';

import '../utils/customLog/debug_log.dart';

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
          return FutureBuilder(
            future: FolderFirebaseStorage().allFolders(ownerUserId: user.uID!),
            builder: (context, snapshot) {
              return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppbar(
                  isBackBtn: false,
                  handleBackBtn: (() {
              }),
                  extraActions: <Widget>[
                    Image.network(user.photoUrl!),
                  ],
              title: "All Notes",
            ),
            body: SafeArea(
                    child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Center(
                    child: GridView.builder(
                        itemCount: Folders.folders.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return FolderWidget(
                            folder: Folders.folders[index],
                            onTap: () {},
                            onTapSetting: () {},
                          );
                        }),
                  ),
                )),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 104.h, right: 44.w),
                  child: FloatingActionButton(
                    onPressed: () {},
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

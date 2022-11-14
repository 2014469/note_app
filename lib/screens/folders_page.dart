import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/folders/folders.dart';
import 'package:provider/provider.dart';

import '../models/folder_note.dart';
import '../models/folders.dart';
import '../resources/constants/asset_path.dart';
import '../services/auth/auth_service.dart';
import '../services/cloud/folder/folder_storage_firebase.dart';
import '../utils/customLog/debug_log.dart';
import '../utils/show_snack_bar.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  AuthUser user = AuthUser();
  @override
  void initState() {
    super.initState();
    Folders.folders = [];
    handleGetAllFolders();
  }

  @override
  void dispose() {
    super.dispose();
    Folders.folders = [];
  }

  void handleCreateNewFolder() async {
    Folder newFolder = await FolderFirebaseStorage()
        .createNewFolder(ownerUserId: user.uID!, nameFolder: "Hello world");

    newFolder.printInfo();
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
    // return Scaffold(
    //   appBar: CustomAppbar(
    //     handleBackBtn: () {},
    //     title: "UniNote",
    //     isBackBtn: false,
    //   ),
    //   body: SafeArea(
    //       child: Center(
    //     child: GridView.builder(
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //         itemBuilder: (context, index) {
              
    //         }),
    //   )),
    //   floatingActionButton: Padding(
    //     padding: EdgeInsets.only(bottom: 104.h, right: 44.w),
    //     child: FloatingActionButton(
    //       onPressed: () {},
    //       child: Image.asset(AssetPaths.addFolder),
    //     ),
    //   ),
    // );


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
      appBar: CustomAppbar(
        handleBackBtn: () {},
        title: "UniNote",
        isBackBtn: false,
      ),
      body: SafeArea(
          child: Center(
        child: GridView.builder(
            itemCount: Folders.folders.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              handleGetAllFolders();
              return FolderGrid(isLocked: true, onTap: (){}, onTapSetting: (){}, title: Folders.folders[index].name,);
            }),
      )),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 104.h, right: 44.w),
        child: FloatingActionButton(
          onPressed: () {},
          child: Image.asset(AssetPaths.addFolder),
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

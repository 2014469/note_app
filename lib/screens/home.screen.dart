import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/screens/folders/folder.widget.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/cloud/note/firebase_note_storage.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/utils/show_snack_bar.dart';

import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/avatar/avatar_appbar.dart';
import 'package:note_app/widgets/search/search_bar.dart';
import 'package:provider/provider.dart';

import '../models/folder.dart';
import '../providers/auth.provider.dart';
import '../providers/folder.provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProvider userProvider;
  late FolderProvider folderProvider;

  @override
  void initState() {
    folderProvider = Provider.of<FolderProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser();
    folderProvider.fetchAllFolders();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleCreateNewFolder(String nameFolder) async {
    folderProvider.addFolders(nameFolder: nameFolder);
  }

  void handleCreateNewNote(String idFolder) async {}

  void handleGetAllNotes(String idFolder) async {
    try {
      await NoteFirebaseStorage().allNotes(
          ownerUserId: userProvider.getCurrentUser.uID!,
          folderOwnerId: idFolder);
    } catch (e) {
      showSnackBarError(context, e.toString());
    }
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushNamed(Routes.notes);
    });
  }

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
          Navigator.of(context).pushNamed(Routes.infoUser);
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
    UserProvider userProviderValue = Provider.of<UserProvider>(context);
    FolderProvider folderProviderValue = Provider.of<FolderProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        isBackBtn: false,
        handleBackBtn: (() {}),
        extraActions: <Widget>[
          PopupMenuButton<int>(
            icon: AvatarAppbarWidget(
              urlPhoto: userProviderValue.getCurrentUser.photoUrl!,
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
          SearchBar(
            controller: _textFieldController,
          ),
          Expanded(
            child: GridView.builder(
                itemCount: folderProviderValue.getFolders.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Folder folder = folderProviderValue.getFolders[index];
                  return FolderWidget(
                    folder: folder,
                    onTap: () => Navigator.of(context).pushNamed(Routes.notes,
                        arguments: {"folderId": folder.folderId}),
                    onTapSetting: () {
                      handleCreateNewNote(folder.folderId);
                    },
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
              handleCreateNewFolder(a);
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
  }
}

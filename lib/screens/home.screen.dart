import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/models/folder_note.dart';
import 'package:note_app/models/folders.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/notes.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/folders/folder.widget.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/cloud/folder/folder_storage_firebase.dart';
import 'package:note_app/services/cloud/note/firebase_note_storage.dart';
import 'package:note_app/utils/customLog/debug_log.dart';
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
  Color folderColor = AppColors.primary;
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

  // void handleCreateNewFolder() async {
  //   Folder newFolder = await FolderFirebaseStorage()
  //       .createNewFolder(ownerUserId: user.uID!, nameFolder: "Hello world");

  //   newFolder.printInfo();
  // }

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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            title: Text(
              'New folder',
              style: AppTextStyles.h4[TextWeights.semibold]
                  ?.copyWith(color: AppColors.primary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                      hintText: "Folder Name",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray[40]!)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.yellowGold)),
                      hintStyle: AppTextStyles.subtitile[TextWeights.regular]
                          ?.copyWith(color: AppColors.gray[80])),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary),
                        onPressed: () {
                          pickColor(context);
                        },
                        child: Text(
                          "Choose Color",
                          style: AppTextStyles.subtitile[TextWeights.medium]
                              ?.copyWith(color: AppColors.gray[0]),
                        )),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          color: folderColor, shape: BoxShape.circle),
                    )
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancel",
                  style: AppTextStyles.h6[TextWeights.semibold]
                      ?.copyWith(color: AppColors.primary),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  'OK',
                  style: AppTextStyles.h6[TextWeights.semibold]
                      ?.copyWith(color: AppColors.primary),
                ),
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

  Widget buildColorPicker() => ColorPicker(
      pickerColor: folderColor,
      onColorChanged: (color) => setState(() {
            folderColor = color;
          }));

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick your color"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildColorPicker(),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("SELECT"))
              ],
            ),
          ));

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
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: AppColors.background,
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
                    SearchBar(
                      controller: _textFieldController,
                    ),
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
                              color: HexColor.fromHex(folder.color!),
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.notes, arguments: {
                                "userId": user.uID,
                                "folderId": folder.folderId
                              }),
                              onTapSetting: () {
                                showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.all(17.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.gray[70]!,
                                                      width: 0.3),
                                                ),
                                                hintText: folder.name,
                                                hintStyle: AppTextStyles
                                                    .h6[TextWeights.semibold]
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .gray[60])),
                                          ),
                                          ListTile(
                                            leading: SvgPicture.asset(
                                                AssetPaths.key),
                                            title: Text(
                                              "Set Password",
                                              style: AppTextStyles
                                                  .caption[TextWeights.medium]
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.gray[70]),
                                            ),
                                            onTap: () {
                                              DebugLog.myLog("Set password");
                                            },
                                          ),
                                          ListTile(
                                            leading: SvgPicture.asset(
                                                AssetPaths.setColor),
                                            title: Text(
                                              "Set Color",
                                              style: AppTextStyles
                                                  .caption[TextWeights.medium]
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.gray[70]),
                                            ),
                                            onTap: () {
                                              DebugLog.myLog("Set Color");
                                            },
                                          ),
                                          ListTile(
                                            leading: SvgPicture.asset(
                                                AssetPaths.select),
                                            title: Text(
                                              "Select",
                                              style: AppTextStyles
                                                  .caption[TextWeights.medium]
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.gray[70]),
                                            ),
                                            onTap: () {
                                              DebugLog.myLog("Select");
                                            },
                                          ),
                                          ListTile(
                                            leading: SvgPicture.asset(
                                                AssetPaths.duplicate),
                                            title: Text(
                                              "Duplicate",
                                              style: AppTextStyles
                                                  .caption[TextWeights.medium]
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.gray[70]),
                                            ),
                                            onTap: () {
                                              DebugLog.myLog("Duplicate");
                                            },
                                          ),
                                          ListTile(
                                            leading: SvgPicture.asset(
                                                AssetPaths.delete),
                                            title: Text(
                                              "Delete",
                                              style: AppTextStyles
                                                  .caption[TextWeights.medium]
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.gray[70]),
                                            ),
                                            onTap: () {
                                              DebugLog.myLog("Delete");
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
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
                      String colorString = folderColor.toString();
                      String valueString =
                          colorString.split('(0x')[1].split(')')[0];
                      String? a = await _showTextInputDialog(context);

                      if (a != null) {
                        Folder newFolder = await FolderFirebaseStorage()
                            .createNewFolder(
                                ownerUserId: user.uID!,
                                nameFolder: a,
                                colorString: valueString);

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

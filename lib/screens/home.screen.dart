import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/folders/folder.widget.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/cloud/note/firebase_note_storage.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/utils/show_snack_bar.dart';

import 'package:provider/provider.dart';

import '../models/folder.dart';
import '../providers/auth.provider.dart';
import '../providers/folder.provider.dart';
import '../utils/customLog/debug_log.dart';
import '../widgets/bar/app_bar.dart';
import '../widgets/drawer/drawer_side.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProvider userProvider;
  late FolderProvider folderProvider;

  Color folderColor = AppColors.primary;
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

  Widget buildColorPicker() => ColorPicker(
      pickerColor: folderColor,
      onColorChanged: (color) => setState(() {
            log(colorToHex(color));
            folderColor = color;
          }));

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            title: const Text("Pick your color"),
            actionsPadding: EdgeInsets.zero,
            actions: [
              Center(
                child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "SELECT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    )),
              ),
            ],
            content: SingleChildScrollView(
              child: buildColorPicker(),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    UserProvider userProviderValue = Provider.of<UserProvider>(context);
    FolderProvider folderProviderValue = Provider.of<FolderProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const DrawerSide(),
      appBar: CustomAppbar(
        isBackBtn: false,
        handleBackBtn: (() {}),
        extraActions: <Widget>[
          // PopupMenuButton<int>(
          //   icon: AvatarAppbarWidget(
          //     urlPhoto: userProviderValue.getCurrentUser.photoUrl!,
          //   ),
          //   onSelected: (value) {
          //     onSelectPopUpMenu(context, value);
          //   },
          //   itemBuilder: (context) => [
          //     const PopupMenuItem(
          //       value: 0,
          //       child: Text("Your profile"),
          //     ),
          //     const PopupMenuItem(
          //       value: 1,
          //       child: Text("Logout"),
          //     ),
          //     const PopupMenuItem(
          //       value: 2,
          //       child: Text("Delete account"),
          //     ),
          //   ],
          // ),
          // todo: search

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

//todo:  sort
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
        title: "UniNotes",
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.w),
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
                        padding: EdgeInsets.all(16.h),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.gray[70]!,
                                          width: 0.3),
                                    ),
                                    hintText: folder.name,
                                    hintStyle: AppTextStyles
                                        .h6[TextWeights.semibold]
                                        ?.copyWith(color: AppColors.gray[60])),
                              ),
                              ListTile(
                                leading: SvgPicture.asset(
                                  AssetPaths.key,
                                ),
                                title: Text(
                                  "Set Password",
                                  style: AppTextStyles
                                      .caption[TextWeights.medium]
                                      ?.copyWith(color: AppColors.gray[70]),
                                ),
                                onTap: () {
                                  DebugLog.myLog("Set password");
                                },
                              ),
                              ListTile(
                                leading: SvgPicture.asset(AssetPaths.setColor),
                                title: Text(
                                  "Set Color",
                                  style: AppTextStyles
                                      .caption[TextWeights.medium]
                                      ?.copyWith(color: AppColors.gray[70]),
                                ),
                                onTap: () {
                                  DebugLog.myLog("Set Color");
                                },
                              ),
                              ListTile(
                                leading: SvgPicture.asset(AssetPaths.select),
                                title: Text(
                                  "Select",
                                  style: AppTextStyles
                                      .caption[TextWeights.medium]
                                      ?.copyWith(color: AppColors.gray[70]),
                                ),
                                onTap: () {
                                  DebugLog.myLog("Select");
                                },
                              ),
                              ListTile(
                                leading: SvgPicture.asset(AssetPaths.duplicate),
                                title: Text(
                                  "Duplicate",
                                  style: AppTextStyles
                                      .caption[TextWeights.medium]
                                      ?.copyWith(color: AppColors.gray[70]),
                                ),
                                onTap: () {
                                  DebugLog.myLog("Duplicate");
                                },
                              ),
                              ListTile(
                                leading: SvgPicture.asset(AssetPaths.delete),
                                title: Text(
                                  "Delete",
                                  style: AppTextStyles
                                      .caption[TextWeights.medium]
                                      ?.copyWith(color: AppColors.gray[70]),
                                ),
                                onTap: () {
                                  DebugLog.myLog("Delete");
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
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

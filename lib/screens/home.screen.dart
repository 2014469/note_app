import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/screens/folders/folder.widget.dart';
import 'package:note_app/utils/routes/routes.dart';

import 'package:provider/provider.dart';

import '../models/folder.dart';
import '../providers/auth.provider.dart';
import '../providers/folder.provider.dart';
import '../providers/home_screen.provider.dart';
import '../resources/fonts/enum_text_styles.dart';
import '../resources/fonts/text_styles.dart';
import '../utils/show_snack_bar.dart';
import '../widgets/bar/app_bar.dart';
import '../widgets/bar/bottom_bar.dart';
import '../widgets/buttons/button_app_bar.dart';
import 'extend_screens/drawer_side.dart';
import 'folders/modal_bottom.widget.dart';
import 'folders/multi_select_folder.dart';
import 'folders/popup_folder_sort.dart';
import 'folders/search_folder_delegate.dart';
import 'folders/show_text_input_name.dart';

enum TypeFolderName { create, edit }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FolderProvider folderProvider;
  late HomeScreenProvider homeScreenProvider;

  late UserProvider userProvider;
  late Future<void>? _getItems;

  @override
  void initState() {
    folderProvider = Provider.of<FolderProvider>(context, listen: false);

    homeScreenProvider = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleCreateNewFolder(String nameFolder) async {
    folderProvider.addFolders(nameFolder: nameFolder);
    homeScreenProvider.changeReload(false);
  }

  bool isSelectionAll() =>
      homeScreenProvider.getSelectedItemSet.length !=
      folderProvider.getFolders.length;

  void doAllSelection() {
    homeScreenProvider.changeReload(false);
    for (var folder in folderProvider.getFolders) {
      homeScreenProvider.addSelection(folder);
    }
  }

  void deleteFoldersSelection() {
    for (var noteSelected in homeScreenProvider.getSelectedItemSet) {
      folderProvider.deleteFolder(noteSelected.folderId);
    }

    homeScreenProvider.clearAndCancelSelectionMode();

    showSnackBarSuccess(context, "Deleted sucessfully");
  }

  @override
  Widget build(BuildContext context) {
    FolderProvider folderProviderValue = Provider.of<FolderProvider>(context);

    HomeScreenProvider homeScreenProviderValue = Provider.of(context);

    _getItems =
        homeScreenProvider.getReload ? folderProvider.fetchAllFolders() : null;
    return Scaffold(
      bottomNavigationBar: FutureBuilder(
        future: _getItems,
        builder: (context, snapshot) {
          return BottomBarCustom(
            title: homeScreenProviderValue.getIsMultiSelectionMode
                ? "${homeScreenProviderValue.getSelectedItemSet.length} folders selected"
                : "${folderProviderValue.getFolders.length} folders",
            isLeft: homeScreenProviderValue.getIsMultiSelectionMode,
            actionLeft: () {},
            textLeft: "",
            textRight:
                homeScreenProviderValue.getIsMultiSelectionMode ? "Delete" : "",
            actionRight: homeScreenProviderValue.getIsMultiSelectionMode
                ? () {
                    deleteFoldersSelection();
                  }
                : () {},
          );
        },
      ),
      backgroundColor: AppColors.background,
      drawer: const DrawerSide(),
      appBar: CustomAppbar(
        isBackBtn: false,
        handleBackBtn: (() {}),
        isSelectionMode: homeScreenProviderValue.getIsMultiSelectionMode,
        isTitle: !homeScreenProviderValue.getIsMultiSelectionMode,
        leadingButton: homeScreenProviderValue.getIsMultiSelectionMode
            ? ButtonAppbar(
                backgroundColor: AppColors.brightRed,
                foregroundColor: AppColors.red,
                nameBtn: isSelectionAll() ? "Select All" : "Deselect All",
                styleBtnText: isSelectionAll()
                    ? AppTextStyles.subtitile[TextWeights.semibold]!
                        .copyWith(color: AppColors.red)
                    : AppTextStyles.body2[TextWeights.bold]!
                        .copyWith(color: AppColors.red),
                onPress: () {
                  isSelectionAll()
                      ? doAllSelection()
                      : homeScreenProvider.clearMultiSelection();
                },
              )
            : null,
        extraActions: homeScreenProviderValue.getIsMultiSelectionMode
            ? [
                ButtonAppbar(
                  backgroundColor: AppColors.brightGreen,
                  foregroundColor: AppColors.green,
                  nameBtn: "Cancel",
                  onPress: () {
                    homeScreenProvider.clearAndCancelSelectionMode();
                    showSnackBarInfo(context, "Bạn đã hủy");
                  },
                )
              ]
            : [
                InkWell(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: BuildSearchFoldersDelegate(
                          folders: folderProviderValue.getFolders),
                      useRootNavigator: false,
                    );
                  },
                  child: const Icon(
                    Icons.search,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showPopupMenuSortFolders(context, details.globalPosition);
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
        child: FutureBuilder(
          future: _getItems,
          builder: (context, snapshot) {
            return GridView.builder(
                itemCount: folderProviderValue.getFolders.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Folder folder = folderProviderValue.getFolders[index];
                  return homeScreenProviderValue.getIsMultiSelectionMode
                      ? MultiSelectFolders(
                          folder: folder,
                        )
                      : FolderWidget(
                          folder: folder,
                          onTap: () => Navigator.of(context).pushNamed(
                              Routes.notes,
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
                                return ModalBottomFolderSheet(
                                  folder: folder,
                                );
                              },
                            );
                          },
                        );
                });
          },
        ),
      )),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 104.h, right: 20.w),
        child: FloatingActionButton(
          onPressed: () async {
            String? a =
                await showTextInputDialog(context, TypeFolderName.create);
            if (a != null && a != "") {
              handleCreateNewFolder(toBeginningOfSentenceCase(a)!);
            } else {
              Future.delayed(Duration.zero, () {
                showSnackBarInfo(context, "Canceled");
              });
            }
          },
          child: Image.asset(AssetPaths.addFolder),
        ),
      ),
    );
  }
}

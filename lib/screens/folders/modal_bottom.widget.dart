import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/folder.dart';
import '../../providers/folder.provider.dart';
import '../../providers/home_screen.provider.dart';
import '../../resources/colors/colors.dart';
import '../../resources/constants/asset_path.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';
import '../../utils/customLog/debug_log.dart';
import '../../utils/show_snack_bar.dart';
import '../home.screen.dart';
import 'edit_name_folder.dart';

class ModalBottomFolderSheet extends StatefulWidget {
  final Folder folder;
  const ModalBottomFolderSheet({
    super.key,
    required this.folder,
  });

  @override
  State<ModalBottomFolderSheet> createState() => _ModalBottomFolderSheetState();
}

class _ModalBottomFolderSheetState extends State<ModalBottomFolderSheet> {
  late FolderProvider folderProvider;
  late HomeScreenProvider homeScreenProvider;

  Color? _tempMainColor;
  Color? mainColor = Colors.blue;

  @override
  void initState() {
    folderProvider = Provider.of(context, listen: false);
    homeScreenProvider = Provider.of(context, listen: false);
    super.initState();
  }

  void changeColorFolder(Folder folder) async {
    folder.color != "" && folder.color != null
        ? changeColor(HexColor.fromHex(folder.color!))
        : null;

    _openFullMaterialColorPicker(folder);
  }

  void changeColor(Color color) {
    homeScreenProvider.changeReload(false);
    setState(() {
      mainColor = _tempMainColor;
    });
  }

  void _openDialog(String title, Widget content, Folder folder) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: AppTextStyles.h6[TextWeights.regular]!
                    .copyWith(color: AppColors.primary),
              ),
            ),
            TextButton(
              child: Text(
                'SUBMIT',
                style: AppTextStyles.h6[TextWeights.regular]!
                    .copyWith(color: AppColors.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                setState(() {
                  changeColor(_tempMainColor!);
                  homeScreenProvider.changeReload(false);
                  setState(() {
                    folder.color = mainColor!.toHex();
                  });
                  folderProvider.updateFolder(folder);
                  log("Color main la: ${mainColor!.toHex()}");
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _openFullMaterialColorPicker(Folder folder) async {
    _openDialog(
      "Chọn màu",
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: mainColor,
        onColorChange: (color) {
          homeScreenProvider.changeReload(false);
          setState(() {
            _tempMainColor = color;
          });
        },
        onMainColorChange: (color) {
          homeScreenProvider.changeReload(false);
          setState(() {
            _tempMainColor = color;
          });
        },
      ),
      folder,
    );
  }

  void changeNameFolder(Folder folder) async {
    String? a = await showDialog(
        context: context,
        builder: (context) {
          return EditFolderName(
            typeFolderName: TypeFolderName.edit,
            name: folder.name,
          );
        });

    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop();

      if (a != null && a != "") {
        setState(() {
          homeScreenProvider.changeReload(false);
          setState(() {
            folder.name = a;
          });
          folderProvider.updateFolder(folder);
        });
      } else {
        showSnackBarInfo(context, "Đã hủy");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 12.w, top: 8.h, bottom: 20.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.gray[80]!,
                    width: 0.8.h,
                  ),
                ),
              ),
              child: Text(
                widget.folder.name,
                style: AppTextStyles.h5[TextWeights.semibold]!
                    .copyWith(color: AppColors.gray[70]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                AssetPaths.key,
              ),
              title: Text(
                "Change name",
                style: AppTextStyles.h6[TextWeights.medium]
                    ?.copyWith(color: AppColors.gray[70]),
              ),
              onTap: () {
                changeNameFolder(widget.folder);
              },
            ),
            Divider(
              height: 1.h,
              thickness: 1.h,
            ),
            ListTile(
              leading: SvgPicture.asset(AssetPaths.setColor),
              title: Text(
                "Set Color",
                style: AppTextStyles.h6[TextWeights.medium]
                    ?.copyWith(color: AppColors.gray[70]),
              ),
              onTap: () {
                DebugLog.i("chang color");
                changeColorFolder(widget.folder);
              },
            ),
            Divider(
              height: 1.h,
              thickness: 1.h,
            ),
            ListTile(
              leading: SvgPicture.asset(AssetPaths.select),
              title: Text(
                "Select",
                style: AppTextStyles.h6[TextWeights.medium]
                    ?.copyWith(color: AppColors.gray[70]),
              ),
              onTap: () {
                homeScreenProvider.changeReload(false);
                homeScreenProvider.changeIsMultiSelectionMode(true);
                Navigator.of(context).pop();
              },
            ),
            Divider(
              height: 1.h,
              thickness: 1.h,
            ),
            ListTile(
              leading: SvgPicture.asset(AssetPaths.duplicate),
              title: Text(
                "Duplicate",
                style: AppTextStyles.h6[TextWeights.medium]
                    ?.copyWith(color: AppColors.gray[70]),
              ),
              onTap: () {
                DebugLog.myLog("Duplicate");
              },
            ),
            Divider(
              height: 1.h,
              thickness: 1.h,
            ),
            ListTile(
              leading: SvgPicture.asset(AssetPaths.delete),
              title: Text(
                "Delete",
                style: AppTextStyles.h6[TextWeights.medium]
                    ?.copyWith(color: AppColors.gray[70]),
              ),
              onTap: () {
                Navigator.of(context).pop();
                folderProvider.deleteFolder(widget.folder.folderId);
                homeScreenProvider.changeReload(false);
                showSnackBarSuccess(context, "Xóa thành công");
              },
            ),
          ],
        ),
      ),
    );
  }
}

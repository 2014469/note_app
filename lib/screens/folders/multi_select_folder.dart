import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/folder.dart';
import '../../providers/home_screen.provider.dart';
import 'folder.widget.dart';

// ignore: must_be_immutable
class MultiSelectFolders extends StatelessWidget {
  final Folder folder;
  MultiSelectFolders({
    super.key,
    required this.folder,
  });

  late HomeScreenProvider homeScreenProvider;

  void doMultiSelection(Folder folder) {
    if (homeScreenProvider.getIsMultiSelectionMode) {
      homeScreenProvider.doMultiSelection(folder);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    homeScreenProvider = Provider.of(context);
    return Stack(
      children: [
        FolderWidget(
          folder: folder,
          onTapSetting: () {},
          isShowMore: false,
          onTap: () {
            doMultiSelection(folder);
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
          child: Align(
            alignment: Alignment.topRight,
            child: Visibility(
              child: Icon(
                homeScreenProvider.getSelectedItemSet.contains(folder)
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 30.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

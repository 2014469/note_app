import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/folder.provider.dart';
import '../../providers/home_screen.provider.dart';

void showPopupMenuSortFolders(BuildContext context, Offset offset) async {
  FolderProvider folderProvider = Provider.of(context, listen: false);
  HomeScreenProvider homeScreenProvider = Provider.of(context, listen: false);
  double left = offset.dx;
  double top = offset.dy;
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(left, top + 24.h, 0, 0),
    items: [
      PopupMenuItem<String>(
        onTap: () {
          if (folderProvider.typeSortCurrent != TypeSortFolder.nameInc) {
            folderProvider.sort(TypeSortFolder.nameInc);
          } else {
            folderProvider.sort(TypeSortFolder.nameDec);
          }
          homeScreenProvider.changeReload(false);
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Name"),
          SizedBox(
            width: 50.w,
          ),
          const Icon(Icons.sort_by_alpha),
        ]),
      ),
      PopupMenuItem<String>(
        onTap: () {
          if (folderProvider.typeSortCurrent != TypeSortFolder.dateDec) {
            folderProvider.sort(TypeSortFolder.dateDec);
          } else {
            folderProvider.sort(TypeSortFolder.dateInc);
          }
          homeScreenProvider.changeReload(false);
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Date"),
          SizedBox(
            width: 50.w,
          ),
          const Icon(Icons.date_range),
        ]),
      ),
      PopupMenuItem<String>(
        onTap: () {
          if (folderProvider.typeSortCurrent != TypeSortFolder.colorInc) {
            folderProvider.sort(TypeSortFolder.colorInc);
          } else {
            folderProvider.sort(TypeSortFolder.colorDec);
          }
          homeScreenProvider.changeReload(false);
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Color tag"),
          SizedBox(
            width: 50.w,
          ),
          const Icon(Icons.color_lens),
        ]),
      ),
    ],
    elevation: 8.0,
  );
}

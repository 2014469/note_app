import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/note.provider.dart';
import '../../../../providers/note_screen.provider.dart';

void showPopupMenuSort(BuildContext context, Offset offset) async {
  NoteProvider noteProvider = Provider.of(context, listen: false);
  NoteScreenProvider noteScreenProvider = Provider.of(context, listen: false);
  double left = offset.dx;
  double top = offset.dy;
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(left, top + 24.h, 0, 0),
    items: [
      PopupMenuItem<String>(
        onTap: () {
          if (noteProvider.typeSortCurrent != TypeSortNote.titleInc) {
            noteProvider.sort(TypeSortNote.titleInc);
          } else {
            noteProvider.sort(TypeSortNote.titleDec);
          }
          noteScreenProvider.changeReload(false);
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
          if (noteProvider.typeSortCurrent != TypeSortNote.dateDec) {
            noteProvider.sort(TypeSortNote.dateDec);
          } else {
            noteProvider.sort(TypeSortNote.dateInc);
          }
          noteScreenProvider.changeReload(false);
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
          if (noteProvider.typeSortCurrent != TypeSortNote.colorInc) {
            noteProvider.sort(TypeSortNote.colorInc);
          } else {
            noteProvider.sort(TypeSortNote.colorDec);
          }
          noteScreenProvider.changeReload(false);
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

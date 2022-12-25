import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../models/note.dart';
import '../../../../providers/note_screen.provider.dart';
import 'note_tile.widget.dart';

class MultiSelectNotes extends StatelessWidget {
  final Note note;
  final bool isDivider;
  MultiSelectNotes({
    super.key,
    required this.note,
    required this.isDivider,
  });

  late NoteScreenProvider noteScreenProvider;

  void doMultiSelection(Note note) {
    if (noteScreenProvider.getIsMultiSelectionMode) {
      noteScreenProvider.doMultiSelection(note);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    noteScreenProvider = Provider.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            child: Icon(
              noteScreenProvider.getSelectedItemSet.contains(note)
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 30.w,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50.w,
            child: NoteListTileWidget(
              isDivider: isDivider,
              note: note,
              onTap: () {
                doMultiSelection(note);
                // Navigator.of(context).pushNamed(
                //   Routes.editNote,
                //   arguments: {
                //     "type": NoteType.editNote,
                //     "folderId": folderId,
                //     "note": note,
                //   },
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

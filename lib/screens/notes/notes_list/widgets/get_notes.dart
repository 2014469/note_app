import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';

import '../../../../models/note.dart';
import '../../../../providers/note.provider.dart';
import '../../../../providers/note_screen.provider.dart';
import '../../../../resources/colors/colors.dart';
import '../../type.dart';
import 'multi_select_notes.widget.dart';
import 'note.widget.dart';

List<Widget> getChildrenNote(
    BuildContext context, PinType type, String folderId) {
  NoteProvider noteProviderValue = Provider.of<NoteProvider>(context);
  List<Widget> results = [];
  switch (type) {
    case PinType.all:
      {
        results =
            List<Widget>.generate(noteProviderValue.getNotes.length, (index) {
          bool isDivider = true;
          Note note = noteProviderValue.getNotes[index];
          if (index == noteProviderValue.getNotes.length - 1) {
            isDivider = false;
          }
          return noteChild(context, note, isDivider, folderId);
        });
        break;
      }
    case PinType.pin:
      {
        results =
            List<Widget>.generate(noteProviderValue.getLengthPins, (index) {
          bool isDivider = true;
          Note note = noteProviderValue.getPinNotes[index];
          if (index == noteProviderValue.getLengthPins - 1) {
            isDivider = false;
          }
          return noteChild(context, note, isDivider, folderId);
        });
        break;
      }
    case PinType.unpin:
      {
        results =
            List<Widget>.generate(noteProviderValue.getLengthUnPins, (index) {
          bool isDivider = true;
          Note note = noteProviderValue.getUnPinNotes[index];
          if (index == noteProviderValue.getLengthUnPins - 1) {
            isDivider = false;
          }
          return noteChild(context, note, isDivider, folderId);
        });
        break;
      }
  }
  return results;
}

Widget noteChild(
    BuildContext context, Note note, bool isDivider, String folderId) {
  NoteScreenProvider noteScreenProvider = Provider.of(context);

  return noteScreenProvider.getIsMultiSelectionMode
      ? MultiSelectNotes(
          note: note,
          isDivider: isDivider,
        )
      : NoteSlideWidget(
          note: note,
          isDivider: isDivider,
          folderId: folderId,
          extraFocusMenuItems: [
            FocusedMenuItem(
              title: const Text(
                "Select Notes",
                style: TextStyle(color: AppColors.green),
              ),
              trailingIcon: const Icon(
                Icons.check_circle,
                color: AppColors.green,
              ),
              onPressed: () {
                noteScreenProvider.changeReload(false);
                noteScreenProvider.changeIsMultiSelectionMode(true);
              },
            ),
          ],
        );
}

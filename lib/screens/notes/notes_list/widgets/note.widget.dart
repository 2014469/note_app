import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';

import '../../../../models/note.dart';
import '../../../../providers/note.provider.dart';
import '../../../../providers/note_screen.provider.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../utils/show_snack_bar.dart';
import '../../type.dart';
import '../move_notes.screen.dart';
import 'focus_menu.widget.dart';
import 'note_tile.widget.dart';

class NoteSlideWidget extends StatefulWidget {
  final Note note;
  final bool isDivider;
  final String folderId;
  final List<FocusedMenuItem> extraFocusMenuItems;
  const NoteSlideWidget({
    super.key,
    required this.note,
    required this.isDivider,
    required this.folderId,
    this.extraFocusMenuItems = const [],
  });

  @override
  State<NoteSlideWidget> createState() => _NoteSlideWidgetState();
}

class _NoteSlideWidgetState extends State<NoteSlideWidget> {
  late NoteProvider noteProvider;
  late NoteScreenProvider noteScreenProvider;
  Color? _tempMainColor;
  Color? mainColor = Colors.blue;

  @override
  void initState() {
    noteProvider = Provider.of<NoteProvider>(context, listen: false);
    noteScreenProvider =
        Provider.of<NoteScreenProvider>(context, listen: false);
    super.initState();
  }

  void pinNote(Note note) {
    note.isPin = !note.isPin;
    noteProvider.updateNote(widget.folderId, note);
    noteScreenProvider.changeReload(true);
  }

  void deleteNote(Note note) {
    noteProvider.deleteNote(widget.folderId, note.noteId);

    noteScreenProvider.changeReload(true);

    showSnackBarSuccess(context, "Xóa thành công");
  }

  void changeColorNote(Note note) async {
    note.color != "" ? changeColor(HexColor.fromHex(note.color!)) : null;

    _openFullMaterialColorPicker(note);
  }

  void changeColor(Color color) {
    noteScreenProvider.changeReload(false);
    setState(() {
      mainColor = _tempMainColor;
    });
  }

  void _openDialog(String title, Widget content, Note note) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CANCEL'),
            ),
            TextButton(
              child: const Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  changeColor(_tempMainColor!);
                  noteScreenProvider.changeReload(false);
                  setState(() {
                    note.color = mainColor!.toHex();
                  });
                  noteProvider.updateNote(widget.folderId, note);
                  log("Color main la: ${mainColor!.toHex()}");
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _openFullMaterialColorPicker(Note note) async {
    _openDialog(
      "Chọn màu",
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: mainColor,
        onMainColorChange: (color) {
          noteScreenProvider.changeReload(false);
          setState(() {
            _tempMainColor = color;
          });
        },
      ),
      note,
    );
  }

  void handleMoveNotes(Note note) async {
    await Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => SelectFolderToMoveNotes(
          folderIdException: widget.folderId,
        ),
      ),
    )
        .then((value) async {
      await noteProvider.createNewNoteForMove(
          ownerFolderId: value.folderId, note: note);
      noteProvider.deleteNote(widget.folderId, note.noteId);

      noteScreenProvider.changeReload(true);

      Future.delayed(Duration.zero, () {
        showSnackBarSuccess(context, "Moved note");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              pinNote(widget.note);
            },
            backgroundColor: AppColors.yellowGold,
            icon: widget.note.isPin
                ? Icons.usb_off_rounded
                : Icons.push_pin_outlined,
            label: widget.note.isPin ? "Unpin" : "Pin",
          )
        ],
      ),
      endActionPane: ActionPane(motion: const BehindMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            handleMoveNotes(widget.note);
          },
          backgroundColor: Colors.green,
          icon: Icons.folder,
          label: "Move",
        ),
        SlidableAction(
          onPressed: (context) {
            deleteNote(widget.note);
          },
          backgroundColor: Colors.red,
          icon: Icons.delete,
          label: "Delete",
        )
      ]),
      child: FocusedMenuHolder(
        blurBackgroundColor: Colors.black54,
        menuOffset: 10,
        blurSize: 5.0,
        duration: const Duration(milliseconds: 100),
        menuItems: [
              FocusedMenuItem(
                  title: widget.note.isPin
                      ? const Text("Unpin")
                      : const Text("Pin"),
                  trailingIcon: widget.note.isPin
                      ? const Icon(Icons.usb_off_rounded)
                      : const Icon(Icons.push_pin_outlined),
                  onPressed: () {
                    pinNote(widget.note);
                  }),
              FocusedMenuItem(
                  title: const Text("Lock"),
                  trailingIcon: const Icon(Icons.lock),
                  onPressed: () {
                    log("share");
                  }),
              FocusedMenuItem(
                  title: const Text("Change color tag"),
                  trailingIcon: const Icon(Icons.color_lens),
                  onPressed: () {
                    changeColorNote(widget.note);
                  }),
              FocusedMenuItem(
                title: const Text("Move"),
                trailingIcon: const Icon(Icons.drive_folder_upload_rounded),
                onPressed: () {
                  handleMoveNotes(widget.note);
                },
              ),
              FocusedMenuItem(
                title: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.redAccent),
                ),
                trailingIcon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  deleteNote(widget.note);
                },
              ),
            ] +
            widget.extraFocusMenuItems,
        onPressed: () {},
        child: NoteListTileWidget(
          isDivider: widget.isDivider,
          note: widget.note,
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.editNote,
              arguments: {
                "type": NoteType.editNote,
                "folderId": widget.folderId,
                "note": widget.note,
              },
            );
          },
        ),
      ),
    );
  }
}

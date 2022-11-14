
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final QuillController _controller = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        QuillToolbar.basic(controller: _controller),
        Expanded(
          child: QuillEditor.basic(
            controller: _controller,
            readOnly: false, // change to true to be view only mode
          ),
        )
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/buttons/show_more.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: 'Unititled Document');

  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        handleBackBtn: () {},
        isTitle: false,
        extraActions: [
          showMoreBtn(
            () => {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            QuillToolbar.basic(controller: _controller),
            Expanded(
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            )
          ],
        ),
      ),
    );
  }
}

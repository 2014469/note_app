import 'package:flutter/material.dart';

import '../../resources/colors/colors.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';
import '../home.screen.dart';

class EditFolderName extends StatefulWidget {
  final TypeFolderName typeFolderName;
  final String? name;
  const EditFolderName({
    super.key,
    required this.typeFolderName,
    this.name,
  });

  @override
  State<EditFolderName> createState() => _EditFolderNameState();
}

class _EditFolderNameState extends State<EditFolderName> {
  late TextEditingController _textFieldController;

  @override
  void initState() {
    _textFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typeFolderName == TypeFolderName.edit) {
      _textFieldController.text = widget.name!;
    }
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      title: Text(
        widget.typeFolderName == TypeFolderName.create
            ? 'New folder'
            : 'Edit Folder Name',
        style: AppTextStyles.h4[TextWeights.semibold]
            ?.copyWith(color: AppColors.primary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
                hintText: widget.typeFolderName == TypeFolderName.create
                    ? "Folder Name"
                    : "",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gray[40]!)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.yellowGold)),
                hintStyle: AppTextStyles.subtitile[TextWeights.regular]
                    ?.copyWith(color: AppColors.gray[80])),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Cancel".toUpperCase(),
            style: AppTextStyles.h6[TextWeights.semibold]
                ?.copyWith(color: AppColors.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
            child: Text(
              widget.typeFolderName == TypeFolderName.create
                  ? 'CREATE'
                  : 'UPDATE',
              style: AppTextStyles.h6[TextWeights.semibold]
                  ?.copyWith(color: AppColors.primary),
            ),
            onPressed: () {
              Navigator.pop(context, _textFieldController.text);
            }),
      ],
    );
  }
}

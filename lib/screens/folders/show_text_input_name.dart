import 'package:flutter/material.dart';

import '../home.screen.dart';
import 'edit_name_folder.dart';

Future<String?> showTextInputDialog(
    BuildContext context, TypeFolderName typeFolderName) async {
  return showDialog(
      context: context,
      builder: (context) {
        return EditFolderName(
          typeFolderName: typeFolderName,
        );
      });
}

import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/embeds/embed_types.dart';
import 'package:note_app/screens/notes/edit/widget/text_btn_dialog.dart';

import '../../../../utils/devices/device_utils.dart';

Future<MediaPickSetting?> selectCameraPickSetting(BuildContext context) {
  DeviceUtils.hideKeyboard(context);
  return showDialog<MediaPickSetting>(
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: TextButtonDialog(
        onPress: () {
          Navigator.pop(ctx, MediaPickSetting.Camera);
        },
        icon: Icons.camera,
        namebtn: "Capture a photo",
      ),
    ),
  );
}

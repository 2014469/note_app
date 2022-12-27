// ignore: unused_element
import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/embeds/embed_types.dart';
import 'package:note_app/screens/notes/edit/widget/text_btn_dialog.dart';

import '../../../../utils/devices/device_utils.dart';

Future<MediaPickSetting?> selectMediaPickSetting(BuildContext context) {
  DeviceUtils.hideKeyboard(context);
  return showDialog<MediaPickSetting>(
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButtonDialog(
            onPress: () {
              Navigator.pop(ctx, MediaPickSetting.Gallery);
            },
            icon: Icons.collections,
            namebtn: "Gallery",
          ),
          TextButtonDialog(
            onPress: () {
              Navigator.pop(ctx, MediaPickSetting.Link);
            },
            icon: Icons.link,
            namebtn: "Link",
          ),
        ],
      ),
    ),
  );
}

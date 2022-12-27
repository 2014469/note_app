import 'package:flutter/material.dart';

import '../../../../resources/colors/colors.dart';

class TextButtonDialog extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final String namebtn;
  const TextButtonDialog({
    super.key,
    required this.onPress,
    required this.icon,
    required this.namebtn,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress,
      icon: Icon(
        icon,
        color: AppColors.primary,
      ),
      label: Text(
        namebtn,
        style: TextStyle(color: AppColors.gray[80]),
      ),
    );
  }
}

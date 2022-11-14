import 'package:flutter/material.dart';

class DeviceUtils {
  ///
  /// hides the keyboard if its already open
  ///
  static void hideKeyboard(BuildContext context) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }
}

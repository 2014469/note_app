import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/colors/colors.dart';

Widget testBtn(VoidCallback handleBtn) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: 8.w,
      horizontal: 0,
    ),
    child: const Text("hello world"),
  );
}

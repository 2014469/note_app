import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/colors/colors.dart';

Widget showMoreBtn(VoidCallback handleBtn) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: 8.w,
      horizontal: 0,
    ),
    child: OutlinedButton(
      onPressed: handleBtn,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: AppColors.primary,
          width: 3.w,
        ),
        shape: const CircleBorder(),
      ),
      child: Icon(
        Icons.more_horiz,
        color: AppColors.primary,
        size: 32.w,
      ),
    ),
  );
}

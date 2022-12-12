import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/colors/colors.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';

class BottomBarCustom extends StatefulWidget {
  const BottomBarCustom({super.key});

  @override
  State<BottomBarCustom> createState() => _BottomBarCustomState();
}

class _BottomBarCustomState extends State<BottomBarCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.gray[80]!,
            width: 0.3.w,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text("Move",
                  style: AppTextStyles.h6[TextWeights.semibold]!
                      .copyWith(color: AppColors.primary)),
            ),
            Text("2000000 notes",
                style: AppTextStyles.body2[TextWeights.regular]!
                    .copyWith(color: AppColors.gray[50])),
            TextButton(
              onPressed: () {},
              child: Text("Add note",
                  style: AppTextStyles.h6[TextWeights.semibold]!
                      .copyWith(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

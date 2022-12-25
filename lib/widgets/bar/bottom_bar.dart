import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/colors/colors.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';

class BottomBarCustom extends StatelessWidget {
  String title;
  String? textLeft;
  String? textRight;
  bool isLeft;
  bool isRight;
  VoidCallback? actionLeft;
  VoidCallback? actionRight;
  BottomBarCustom({
    super.key,
    required this.title,
    this.textLeft,
    this.isLeft = true,
    this.isRight = true,
    this.textRight,
    this.actionLeft,
    this.actionRight,
  });

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
            isLeft
                ? TextButton(
                    onPressed: actionLeft!,
                    child: Text(textLeft!,
                        style: AppTextStyles.h6[TextWeights.semibold]!
                            .copyWith(color: AppColors.primary)),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2[TextWeights.regular]!.copyWith(
                    color: AppColors.gray[50],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            isRight
                ? TextButton(
                    onPressed: actionRight!,
                    child: Text(textRight!,
                        style: AppTextStyles.h6[TextWeights.semibold]!
                            .copyWith(color: AppColors.primary)),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

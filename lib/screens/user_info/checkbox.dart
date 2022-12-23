import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class AppCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  const AppCheckBox(
      {super.key,
      this.title = 'Text',
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10), color: AppColors.background),
    // );
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 4.w,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: value == true ? AppColors.red : AppColors.background,
            width: 2,
          ),
          color: AppColors.background,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: Checkbox(
              activeColor: AppColors.red,
              shape: const CircleBorder(),
              side: BorderSide(color: AppColors.gray[50]!, width: 2.0),
              value: value,
              onChanged: (value) {
                onChanged(value!);
              },
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Text(title, style: AppTextStyles.subtitile[value?TextWeights.semibold:TextWeights.regular]?.copyWith(color:value?AppColors.red:AppColors.gray[60]),)
        ],
      ),
    );
  }
}

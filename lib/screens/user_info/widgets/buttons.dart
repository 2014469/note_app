import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class ColorButton extends StatelessWidget {
  final bool isLarge;
  final bool isRounded;
  final String text;
  final bool isOpacity;
  final Color color;
  final Function()? onpressed;
  const ColorButton(
      {super.key,
      this.isLarge = true,
      this.isOpacity = true,
      this.isRounded = true,
      required this.text,
      required this.color,
      required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      style: TextButton.styleFrom(
          disabledBackgroundColor: AppColors.gray[10],
          disabledForegroundColor: AppColors.gray[50],
          foregroundColor: isOpacity ? color : AppColors.gray[0],
          elevation: 0,
          minimumSize:
              isLarge ? const Size(double.infinity, 0) : Size(190.w, 0),
          padding: EdgeInsets.symmetric(vertical: isLarge ? 8.h : 12.h),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(isRounded ? 20 : 10))),
          backgroundColor: isOpacity ? color.withOpacity(0.2) : color),
      child: Text(
        text,
        style: isLarge
            ? AppTextStyles.h5[TextWeights.medium]
            : AppTextStyles.subtitile[TextWeights.semibold]
      ),
    );
  }
}

class SmallIconButton extends StatelessWidget {
  final Color color;
  final Function()? onPressed;
  final String btnText;
  final SvgPicture svgIcon;
  const SmallIconButton(
      {super.key,
      this.color = AppColors.primary,
      required this.onPressed,
      required this.btnText,
      required this.svgIcon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h)),
        icon: svgIcon,
        label: Text(
          btnText,
          style: AppTextStyles.caption[TextWeights.regular]
              ?.copyWith(color: AppColors.gray[0]),
        ));
  }
}

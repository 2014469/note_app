import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/fonts/enum_text_styles.dart';
import '../../../../resources/fonts/text_styles.dart';

class ButtonAppbar extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String nameBtn;
  final TextStyle? styleBtnText;
  final VoidCallback onPress;
  const ButtonAppbar({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.nameBtn,
    required this.onPress,
    this.styleBtnText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // <-- Radius
          ),
        ),
        child: Text(
          nameBtn,
          style: styleBtnText ??
              AppTextStyles.subtitile[TextWeights.semibold]!
                  .copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class TitleScreen extends StatelessWidget {
  final String title;
  const TitleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
      ),
      child: Text(
        title,
        style: AppTextStyles.h3[TextWeights.semibold]!
            .copyWith(color: AppColors.primary),
      ),
    );
  }
}

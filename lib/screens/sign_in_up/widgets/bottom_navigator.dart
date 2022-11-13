import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class BottomNavigator extends StatelessWidget {
  final String content;
  final String nameScreenNavigator;
  final VoidCallback handleNavigator;

  const BottomNavigator({
    super.key,
    required this.content,
    required this.nameScreenNavigator,
    required this.handleNavigator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('$content  ',
            style: AppTextStyles.h6[TextWeights.regular]
                ?.copyWith(color: AppColors.gray[70])),
        TextButton(
            onPressed: handleNavigator,
            child: Text(nameScreenNavigator,
                style: AppTextStyles.h5[TextWeights.semibold]
                    ?.copyWith(color: AppColors.primary)))
      ]),
    );
  }
}

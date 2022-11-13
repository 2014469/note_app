import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/widgets/buttons/buttons.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // images logo
            Image.asset(
              AssetPaths.logo,
              width: 200.w,
              height: 200.w,
            ),
            // text notification
            Padding(
              padding: EdgeInsets.only(top: 64.h, bottom: 12.h),
              child: Text(
                'Please check your email',
                textAlign: TextAlign.center,
                style: AppTextStyles.h4[TextWeights.semibold]
                    ?.copyWith(color: AppColors.primary),
              ),
            ),
            Text(
              "We've sent you an email, please click on the link to verify. If you don't see the email, check other places it might be, like your junk, spam, social,or other folders. ",
              textAlign: TextAlign.center,
              style: AppTextStyles.h6[TextWeights.medium]
                  ?.copyWith(color: AppColors.gray[80]),
            ),

            SizedBox(
              height: 60.h,
            ),
            SmallButton(
              isOutlined: false,
              textBtn: "Delete account!",
              onPressed: () {},
            )
          ]),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/utils/show_snack_bar.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late Timer timer;
  late User user;
  late bool _isEmailVerified;

  @override
  void initState() {
    super.initState();
    context.read<AuthService>().sendEmailVerification();

    user = context.read<AuthService>().getUser!;
    _isEmailVerified = user.emailVerified;

    if (!_isEmailVerified) {
      _startEmailVerificationTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  _startEmailVerificationTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer _) {
      user = context.read<AuthService>().reloadCurrentUser();
      if (user.emailVerified == true) {
        setState(() {
          _isEmailVerified = user.emailVerified;
        });
        timer.cancel();
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.authWrapper,
          (route) => false,
        );
      }
    });
  }

  void handleDeleteAccount() async {
    await context.read<AuthService>().deleteAccount();
    Future.delayed(const Duration(seconds: 1), () {
      showSnackBarInfo(context, 'Deleting account!');
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.authWrapper,
        (route) => false,
      );
    });
  }

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
              onPressed: handleDeleteAccount,
            )
          ]),
        ),
      ),
    );
  }
}

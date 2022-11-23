import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/avatar/avatar_appbar.dart';

class InfoUserScreen extends StatelessWidget {
  const InfoUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUser user = (ModalRoute.of(context)!.settings.arguments) as AuthUser;
    return Scaffold(
      appBar: CustomAppbar(
        title: "User info",
        handleBackBtn: (() => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Center(
            child: Column(children: [
              AvatarAppbarWidget(
                urlPhoto: user.photoUrl!,
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(user.displayName!,
                  style: AppTextStyles.h4[TextWeights.semibold]),
              Text(user.email!, style: AppTextStyles.h6[TextWeights.semibold]),
              Text(user.uID!, style: AppTextStyles.h6[TextWeights.semibold]),
              SizedBox(
                height: 100.h,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

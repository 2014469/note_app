import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/user_info/widgets/buttons.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/customLog/debug_log.dart';
import '../../utils/show_snack_bar.dart';
import '../../widgets/bar/app_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    TextEditingController retypePassword = TextEditingController();
    return Scaffold(
        appBar: CustomAppbar(
          title: "Change your password",
          isH6Title: true,
          handleBackBtn: (() => Navigator.of(context).pop()),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Text(
                      "Enter your old password",
                      style: AppTextStyles.h5[TextWeights.semibold]
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
                  PasswordField(controller: oldPassword),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Text(
                      "Enter your new password",
                      style: AppTextStyles.h5[TextWeights.semibold]
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
                  PasswordField(controller: newPassword),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Text(
                      "Re-enter your new password",
                      style: AppTextStyles.h5[TextWeights.semibold]
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
                  PasswordField(controller: retypePassword),
                  SizedBox(
                    height: 24.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "* Password must have more tham 8 characters including at least 1 number, 1 letter and 1 capital letter",
                      style: AppTextStyles.caption[TextWeights.regular]
                          ?.copyWith(color: const Color(0xff0AC174)),
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.5.h, horizontal: 12.w),
                              side:
                                  const BorderSide(color: Colors.transparent)),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Routes.resetPassword),
                          child: Text(
                            'Forgot your password?',
                            style: AppTextStyles.subtitile[TextWeights.semibold]
                                ?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ColorButton(
                            isLarge: false,
                            text: 'Save',
                            isOpacity: true,
                            color: const Color(0xff0ac174),
                            onpressed: () async {
                              try {
                                bool success = await context
                                    .read<AuthService>()
                                    .changePassword(
                                        currentPassword: oldPassword.text,
                                        newPassword: newPassword.text);

                                DebugLog.w(success);
                              } on WrongOldPassWord {
                                showSnackBarError(context, "Sai password cũ");
                              } on ErrorChangePassword {
                                showSnackBarError(context, "Có lỗi đã xảy ra");
                              }
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

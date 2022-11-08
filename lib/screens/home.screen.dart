import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/utils/routes/routes.dart';

import '../utils/customLog/debug_log.dart';
import '../widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        handleBackBtn: (() {
          DebugLog.myLog("Backbtn");
        }),
        handleRightBtn: (() {
          DebugLog.myLog("Right btn");
        }),
        backgroundColor: AppColors.background,
        title: "All Notes",
      ),
      body: SafeArea(
        child: TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  AppColors.gray[70],
                ),
                textStyle: MaterialStateProperty.all(
                    AppTextStyles.body1[TextWeights.bold]),
                padding: MaterialStateProperty.all(EdgeInsets.all(16.w))),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                Routes.login,
              );
            },
            child: const Text(
              "Go to login",
            )),
      ),
    );
  }
}

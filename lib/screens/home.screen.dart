import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/buttons.dart';

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
        title: "All Notes",
      ),
      body: SafeArea(
          child: Column(
        children: [
          TextButton(
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
          LargeButton(
            isOutlined: false,
            text: "Sign in with Google",
            onPressed: () {
              DebugLog.myLog("Large Button Pressed");
            },
          ),
          LargeButton(
            isOutlined: true,
            text: "Sign in with Google",
            onPressed: () {
              DebugLog.myLog("Large Button Pressed");
            },
          ),
          LargeButton(
            isOutlined: false,
            text: "Sign in with Google",
            iconPath: AssetPaths.google,
            onPressed: () {
              DebugLog.myLog("Large Button Pressed");
            },
          ),
          LargeButton(
            isOutlined: true,
            text: "Sign in with Google",
            iconPath: AssetPaths.google,
            onPressed: () {
              DebugLog.myLog("Large Button Pressed");
            },
          ),
          Row(
            children: [
              SmallButton(
                isOutlined: true,
                onPressed: () {
                  DebugLog.myLog("Small button pressed");
                },
              ),
              SmallButton(
                isOutlined: false,
                onPressed: () {
                  DebugLog.myLog("Small button pressed");
                },
              ),
            ],
          )
        ],
      )),
    );
  }
}

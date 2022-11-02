import 'package:flutter/material.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/utils/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
        ),
      ),
      body: SafeArea(
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                AppColors.gray[70],
              ),
              textStyle: MaterialStateProperty.all(AppTextStyles.body1[TextWeights.bold])
            ),
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

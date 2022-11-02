import 'package:flutter/material.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/utils/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TextButton(
          style: ButtonStyle(textStyle: MaterialStateProperty.all(AppTextStyles.h2[TextWeights.bold])),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                Routes.home,
              );
            },
            child: const Text("Go to Home page")),
      ),
    );
  }
}

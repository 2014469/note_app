import 'package:flutter/material.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/widgets/logo/images_logo.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: CustomAppbarLogin(handleBackBtn: () => Navigator.of(context).pop()),
      body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // images logo
      const Padding(
        padding: EdgeInsets.fromLTRB(100, 100, 100, 0),
        child: ImageLogo(),
         ),
         // text notification
          Padding(
        padding: const EdgeInsets.fromLTRB(52, 20, 49, 15),
        child: Text(
          'Note App',
          textAlign: TextAlign.center,
          style: AppTextStyles.h3[TextWeights.semibold]
              ?.copyWith(color: AppColors.primary),
        ),
      ),
        ]
        )
    );
  }
}
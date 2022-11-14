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
          // Padding(
            // padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            
           //),
          //const SizedBox(height: 30),

          // images logo
         Padding(
           padding: const EdgeInsets.fromLTRB(100, 100, 100, 0),
           child: const ImageLogo(),
         ),
         // text notification
          Padding(
            padding: const EdgeInsets.fromLTRB(52, 20, 49, 15),
            child: Container(
              child: Text(
                'Note App',
                textAlign: TextAlign.center,
                style: AppTextStyles.h3[TextWeights.semibold]?.copyWith(color: AppColors.primary),
              ),
              ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 18),
          //   child: Container(           
          //       child: Text(
          //       'we\'ve sent you an email, please click on the link to verify. If you don\'t see the email, check other places it might be, like your junk, spam, social,or other folders. ',
          //       textAlign: TextAlign.center,
          //       style: AppTextStyles.subtitile[TextWeights.semibold]?.copyWith(color: AppColors.gray[100]),
          //       ),
          //   ),
          // ),
              
            
          
        ]
        )
    );
  }
}
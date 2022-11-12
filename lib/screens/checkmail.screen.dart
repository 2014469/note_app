import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/devices/device_utils.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/logo/images_logo.dart';
import 'package:note_app/widgets/text_field/app_bar_login.dart';
import 'package:note_app/widgets/text_field/custom_text_field.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';
import 'package:form_validator/form_validator.dart';



class CheckMail extends StatelessWidget {
  const CheckMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarLogin(handleBackBtn: () => Navigator.of(context).pop()),
      body: Column(
       // mainAxisAlignment: MainAxisAlignment.center,
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
            padding: const EdgeInsets.fromLTRB(52, 64, 49, 15),
            child: Container(
              child: Text(
                'Please check your mail',
                textAlign: TextAlign.center,
                style: AppTextStyles.h5[TextWeights.semibold]?.copyWith(color: AppColors.primary),
              ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(           
                child: Text(
                'we\'ve sent you an email, please click on the link to verify. If you don\'t see the email, check other places it might be, like your junk, spam, social,or other folders. ',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitile[TextWeights.semibold]?.copyWith(color: AppColors.gray[100]),
                ),
            ),
          ),
              
            
          
        ]
        )
    );
  }
}
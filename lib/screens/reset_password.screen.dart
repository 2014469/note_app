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
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/logo/images_logo.dart';
import 'package:note_app/widgets/text_field/app_bar_login.dart';
import 'package:note_app/widgets/text_field/custom_text_field.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';
import 'package:form_validator/form_validator.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();

  // @override
  // void dispose() {
  //  _confirmPasswordController.dispose();
  //   _passwordController.dispose();

  //   super.dispose();
  // }

  // void resetPasswordUser() async {
  //   DeviceUtils.hideKeyboard(context);
  //   context
  //       .read<AuthService>()
  //       .resetPassword(   
  //         password: _passwordController.text,
  //         confirmpassword: _confirmPasswordController.text,

  //       )
  //       .then((value) => (context.read<AuthService>().sendEmailVerification()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarLogin(handleBackBtn: (() => Navigator.of(context).pop())),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          const SizedBox(height: 50),  
          // images logo
         const ImageLogo(),

          // text reset pasword  
         const Padding(
            padding:  EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Text(
              "Reset your password",
              style: TextStyle(fontSize: 30, color: AppColors.primary),
              
            ),
          ),
          
          // edit text 
          PasswordField(controller: _passwordController, hintText: "Password"),
          PasswordField(controller: _retypePasswordController, hintText: 'Retype Password'),
          const SizedBox(height: 10),  

          // button Finissh
          LargeButton(isOutlined: false, onPressed: null, text: "Finish",),

         
           Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom) 
          ),
        ],
        ),
      ),
    );
  }
}

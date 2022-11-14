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
import 'package:note_app/widgets/text_field/custom_text_field.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';
import 'package:form_validator/form_validator.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController inputFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
 
 // values mặc định 
  bool value = false;

  @override
  void dispose() {
    super.dispose();
    inputFieldController.dispose();
    passwordFieldController.dispose();
  }

  void loginUser() async {
    DeviceUtils.hideKeyboard(context);
    context.read<AuthService>().loginEmailPassword(
          email: inputFieldController.text,
          password: passwordFieldController.text,
          
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),  
          // images logo
         const ImageLogo(),

          // text login
         const Padding(
            padding:  EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 30, color: AppColors.primary),       
            ),
            
          ),
          
          // edit text 
          InputField(controller: inputFieldController, hintText: "Email"),
          PasswordField(controller: passwordFieldController, hintText: "Password"),
          const SizedBox(height: 10),

          // remember me and forget password 
          Container(
            child: Row(
              children: [
                Checkbox(
                        value: value,
                        onChanged: (_) {                          
                           setState(() {
                              value = !value;
                           });
                        },
                        ), 
                 Text('Remember me', style: (AppTextStyles.subtitile[TextWeights.semibold]?.copyWith(color: AppColors.gray[70]))),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(101, 0, 0, 0),
                   child: Text('Forget password', style: (AppTextStyles.subtitile[TextWeights.medium]?.copyWith(color: AppColors.gray[70]))),
                 )
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // button login 
          LargeButton(isOutlined: false, onPressed: loginUser, text: "Login",),

          // text or 
          Container(
            child: Center(
                child: Text(
                  'Or',
                  style: AppTextStyles.h5[TextWeights.semibold]?.copyWith(color: AppColors.gray[50]),
                ),
            ),
          ),

          // button sign in with google 
          LargeButton(isOutlined: true , onPressed: (){}, iconPath: AssetPaths.google,text:'Sign in with Google'),
          
          // link to sign up            
           Container(           
            child: Padding(
              padding: const EdgeInsets.fromLTRB(90, 20, 90, 0),
              child: Row(children: [
                Text('New to our app?', style: AppTextStyles.h6[TextWeights.regular]?.copyWith(color: AppColors.gray[70])),
                Text('Sign-Up',style: AppTextStyles.h6[TextWeights.semibold]?.copyWith(color: AppColors.primary))

              ]),
            ),
           ),
           Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom) 
          ),
        ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/logo/images_logo.dart';
import 'package:note_app/widgets/text_field/app_bar_login.dart';
import 'package:note_app/widgets/text_field/text_field.dart';

class WelcomePassword extends StatefulWidget {
  const WelcomePassword({super.key});

  @override
  State<WelcomePassword> createState() => _WelcomePasswordState();
}

class _WelcomePasswordState extends State<WelcomePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool value = false;
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
        appBar: CustomAppbarLogin(
            handleBackBtn: (() => Navigator.of(context).pop())),

        //SingleChildScrollView
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // images logo
              const ImageLogo(),

              // text welcome
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: Text(
                  "Welcome...",
                  style: TextStyle(fontSize: 30, color: AppColors.primary),
                ),
              ),

              // edit text
              PasswordField(
                  controller: _passwordController, hintText: "Password"),
              PasswordField(
                  controller: _retypePasswordController,
                  hintText: 'Retype Password'),

              // check box i agree the mentioned terms
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
                    Text('I agree the mentioned terms',
                        style: (AppTextStyles.subtitile[TextWeights.semibold]
                            ?.copyWith(color: AppColors.gray[70]))),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // button Finish
              const LargeButton(
                isOutlined: false,
                onPressed: null,
                text: "Finish",
              ),

              //
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ));
  }
}

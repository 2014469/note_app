import 'package:flutter/material.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/devices/device_utils.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/logo/images_logo.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void signUpUser() async {
    DeviceUtils.hideKeyboard(context);
    await context.read<AuthService>().signUpEmailPassword(
          username: _userNameController.text,
          email: _confirmPasswordController.text,
          password: _passwordController.text,
        );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.authWrapper,
      (route) => false,
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

              // text sign up
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, color: AppColors.primary),
                ),
              ),

              // edit text
              InputField(controller: _userNameController, hintText: "Email"),
              PasswordField(
                  controller: _passwordController, hintText: "Password"),
              PasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password'),
              const SizedBox(height: 10),

              // button Next
              LargeButton(
                isOutlined: false,
                onPressed: signUpUser,
                text: "Next",
              ),

              // text or
              Container(
                child: Center(
                  child: Text(
                    'Or',
                    style: AppTextStyles.h5[TextWeights.semibold]
                        ?.copyWith(color: AppColors.gray[50]),
                  ),
                ),
              ),

              // button sign in with google
              LargeButton(
                  isOutlined: true,
                  onPressed: () {},
                  iconPath: AssetPaths.google,
                  text: 'Sign up with Google'),

              // link to Login
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 20, 90, 0),
                  child: Row(children: [
                    Text('Had an account?',
                        style: AppTextStyles.h6[TextWeights.regular]
                            ?.copyWith(color: AppColors.gray[70])),
                    Text('Login',
                        style: AppTextStyles.h6[TextWeights.semibold]
                            ?.copyWith(color: AppColors.primary))
                  ]),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ));
  }
}

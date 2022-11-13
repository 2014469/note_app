import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/constants/sign_in_up/str_sign_in.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/sign_in_up/widgets/bottom_navigator.dart';
import 'package:note_app/screens/sign_in_up/widgets/logo.dart';
import 'package:note_app/screens/sign_in_up/widgets/titils_screen.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';

import '../../utils/devices/device_utils.dart';

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
  var _textEmail = '';

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

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.authWrapper,
      (route) => false,
    );
  }

  void naviageToSignUpPage() {
    DeviceUtils.hideKeyboard(context);
    Navigator.of(context).pushNamed(
      Routes.signup,
    );
  }

  void handleContinueWithGoogle() {
    DeviceUtils.hideKeyboard(context);
    context.read<AuthService>().loginWithGoogle();
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    _textEmail = inputFieldController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (_textEmail.isEmpty) {
      return 'Can\'t be empty';
    }
    if (_textEmail.length < 3) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              // images logo
              const Logo(),

              // text login
              const TitleScreen(title: SignInUpString.signin),

              // edit text
              InputField(
                controller: inputFieldController,
                hintText: "Email",
                errorText: _errorText,
                onChanged: (text) => setState(() => _textEmail),
              ),
              PasswordField(
                controller: passwordFieldController,
                hintText: "Password",
                errorText: _errorText,
                onChanged: (text) => setState(
                  () => _textEmail,
                ),
              ),
              // remember me and forget password
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 0.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Checkbox(
                            value: value,
                            onChanged: (_) {
                              setState(() {
                                value = !value;
                              });
                            },
                            fillColor:
                                MaterialStateProperty.all(AppColors.primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            value = !value;
                          }),
                          child: Text('Remember me',
                              style: (AppTextStyles
                                  .subtitile[TextWeights.semibold]
                                  ?.copyWith(color: AppColors.gray[70]))),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text('Forget password',
                            style: (AppTextStyles.subtitile[TextWeights.medium]
                                ?.copyWith(color: AppColors.gray[70]))))
                  ],
                ),
              ),

              // button login
              LargeButton(
                isOutlined: false,
                onPressed: loginUser,
                text: SignInUpString.signin,
              ),

              // text or
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
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
                onPressed: handleContinueWithGoogle,
                iconPath: AssetPaths.google,
                text: SignInUpString.signInWithGoogle,
              ),

              // link to sign up
              BottomNavigator(
                content: 'New to our app?',
                nameScreenNavigator: SignInUpString.signUp,
                handleNavigator: naviageToSignUpPage,
              )
            ],
          ),
        ),
      ),
    );
  }
}

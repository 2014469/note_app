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
import 'package:note_app/services/auth/auth_exceptions.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/utils/show_snack_bar.dart';
import 'package:note_app/utils/validate/utils_validation.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.provider.dart';
import '../../utils/devices/device_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  late UserProvider userProvider;

  // values mặc định
  bool _isRememberme = false;
  bool _isDisabledLoginBtn = true;
  final _textEmail = '';
  final _textPassword = '';
  bool _ignoreTouch = false;

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void loginUser() async {
    DeviceUtils.hideKeyboard(context);
    try {
      setState(() {
        _ignoreTouch = true;
      });
      await context.read<AuthService>().loginEmailPassword(
            email: _emailController.text,
            password: _passController.text,
          );

      await Future.delayed(
        const Duration(seconds: 1),
        () => {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.authWrapper,
            (route) => false,
          )
        },
      );
    } on UserNotLoggedInAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "Authentication error");
    } on UserNotFoundAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "User not found");
    } on WrongPasswordAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "Wrong password");
    } on GenericAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "Authentication error");
    }
  }

  void naviageToSignUpPage() {
    DeviceUtils.hideKeyboard(context);
    Navigator.of(context).pushNamed(
      Routes.signup,
    );
  }

  void handleContinueWithGoogle() async {
    DeviceUtils.hideKeyboard(context);
    try {
      setState(() {
        _ignoreTouch = true;
      });
      await context.read<AuthService>().loginWithGoogle();

      userProvider.setInfoUser();
      userProvider.addUser(user: userProvider.getCurrentUser);
    } on GoogleSignInAccountException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "User not found");
    } on GenericAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarInfo(context, "Authentication error");
    }
  }

  String? get _errorTextEmail {
    String? result = checkEmail(_emailController.value.text);

    if (result == null) {
      setState(() {
        _isDisabledLoginBtn = false;
      });
    } else {
      setState(() {
        _isDisabledLoginBtn = true;
      });
    }
    return result;
  }

  String? get _errorPasswordStrength {
    String? result = checkPassword(_passController.value.text);
    if (result == null) {
      setState(() {
        _isDisabledLoginBtn = false;
      });
    } else {
      setState(() {
        _isDisabledLoginBtn = true;
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: IgnorePointer(
            ignoring: _ignoreTouch,
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
                  controller: _emailController,
                  hintText: "Email",
                  errorText: _errorTextEmail,
                  onChanged: (text) => setState(() => _textEmail),
                ),
                PasswordField(
                  controller: _passController,
                  hintText: "Password",
                  helperText: checkStrengthPassword(_passController.text),
                  errorText: _errorPasswordStrength,
                  onChanged: (text) => setState(
                    () => _textPassword,
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
                              value: _isRememberme,
                              onChanged: (_) {
                                setState(() {
                                  _isRememberme = !_isRememberme;
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.all(AppColors.primary),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              _isRememberme = !_isRememberme;
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
                              style: (AppTextStyles
                                  .subtitile[TextWeights.medium]
                                  ?.copyWith(color: AppColors.gray[70]))))
                    ],
                  ),
                ),

                // button login
                AbsorbPointer(
                  absorbing: _isDisabledLoginBtn,
                  child: LargeButton(
                    isOutlined: false,
                    onPressed: loginUser,
                    text: SignInUpString.signin,
                  ),
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

                LargeButton(
                  isOutlined: true,
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.home);
                  },
                  text: "Without signin",
                ),
                // link to sign up
                BottomNavigator(
                  content: 'New to our app?',
                  nameScreenNavigator: SignInUpString.signUp,
                  handleNavigator: naviageToSignUpPage,
                ),
                // todo:  padding keyboard autoscroll
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

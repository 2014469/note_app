import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/constants/sign_in_up/str_sign_in.dart';
import 'package:note_app/screens/sign_in_up/widgets/bottom_navigator.dart';
import 'package:note_app/screens/sign_in_up/widgets/logo.dart';
import 'package:note_app/screens/sign_in_up/widgets/titils_screen.dart';
import 'package:note_app/services/auth/auth_exceptions.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/devices/device_utils.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/utils/show_snack_bar.dart';
import 'package:note_app/utils/validate/utils_validation.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _textUser = '';
  final _textEmail = '';
  final _textPassword = '';
  final _textPasswordConfirm = '';

// ignore touch butoon, screen
  bool _ignoreTouch = false;
  bool _isDisabledSignupBtn = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void signUpUser() async {
    DeviceUtils.hideKeyboard(context);
    try {
      setState(() {
        _ignoreTouch = true;
      });
      await context.read<AuthService>().signUpEmailPassword(
            username: _userNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
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
    } on EmailAlreadyInUseAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "Email already use");
    } on WeakPasswordAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(context, "Weak password");
    } on InvalidEmailAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(
        context,
        'Invalid email',
      );
    } on GenericAuthException {
      setState(() {
        _ignoreTouch = false;
      });
      showSnackBarError(
        context,
        'Authentication error',
      );
    }
  }

  void naviageToSignInPage() {
    DeviceUtils.hideKeyboard(context);
    Navigator.of(context).pop();
  }

  String? get _errorTextEmail {
    String? result = checkEmail(_emailController.text);

    if (result == null) {
      setState(() {
        _isDisabledSignupBtn = false;
      });
    } else {
      setState(() {
        _isDisabledSignupBtn = true;
      });
    }
    return result;
  }

  String? get _errorPasswordStrength {
    String? result = checkPassword(_passwordController.value.text);
    if (result == null) {
      setState(() {
        _isDisabledSignupBtn = false;
      });
    } else {
      setState(() {
        _isDisabledSignupBtn = true;
      });
    }
    return result;
  }

  String? get _errorPasswordConfirm {
    String? result = checkPasswordConfirmMatch(
        _passwordController.text, _confirmPasswordController.text);

    if (result == null) {
      setState(() {
        _isDisabledSignupBtn = false;
      });
    } else {
      setState(() {
        _isDisabledSignupBtn = true;
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

                const TitleScreen(
                  title: SignInUpString.signUp,
                ),
                // text sign up
                // edit text

                InputField(
                  controller: _userNameController,
                  hintText: "Username",
                  errorText: null,
                  onChanged: (text) => setState(() => _textUser),
                ),
                InputField(
                  controller: _emailController,
                  hintText: "Email",
                  errorText: _errorTextEmail,
                  onChanged: (text) => setState(() => _textEmail),
                ),
                PasswordField(
                  controller: _passwordController,
                  hintText: "Password",
                  helperText: checkStrengthPassword(_passwordController.text),
                  errorText: _errorPasswordStrength,
                  onChanged: (text) => setState(() => _textPassword),
                ),
                PasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  errorText: _errorPasswordConfirm,
                  onChanged: (text) => setState(() => _textPasswordConfirm),
                ),
                // button Next
                AbsorbPointer(
                  absorbing: _isDisabledSignupBtn,
                  child: LargeButton(
                    isOutlined: false,
                    onPressed: signUpUser,
                    text: "Next",
                  ),
                ),
          
                BottomNavigator(
                  content: 'Had an account?',
                  nameScreenNavigator: SignInUpString.signin,
                  handleNavigator: naviageToSignInPage,
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

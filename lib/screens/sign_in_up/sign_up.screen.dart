import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/constants/sign_in_up/str_sign_in.dart';
import 'package:note_app/screens/sign_in_up/widgets/bottom_navigator.dart';
import 'package:note_app/screens/sign_in_up/widgets/logo.dart';
import 'package:note_app/screens/sign_in_up/widgets/titils_screen.dart';
import 'package:note_app/widgets/buttons/buttons.dart';
import 'package:note_app/widgets/text_field/text_field.dart';

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
  var _textEmail = '';

  @override
  void dispose() {
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void signUpUser() async {
    // DeviceUtils.hideKeyboard(context);
    // await context.read<AuthService>().signUpEmailPassword(
    //       username: _userNameController.text,
    //       email: _confirmPasswordController.text,
    //       password: _passwordController.text,
    //     );
    // // ignore: use_build_context_synchronously
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   Routes.authWrapper,
    //   (route) => false,
    // );
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    _textEmail = _userNameController.value.text;
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

              const TitleScreen(
                title: SignInUpString.signUp,
              ),
              // text sign up
              // edit text

              InputField(
                controller: _userNameController,
                hintText: "Username",
                errorText: _errorText,
                onChanged: (text) => setState(() => _textEmail),
              ),
              InputField(
                controller: _userNameController,
                hintText: "Email",
                errorText: _errorText,
                onChanged: (text) => setState(() => _textEmail),
              ),
              PasswordField(
                controller: _passwordController,
                hintText: "Password",
                errorText: _errorText,
                onChanged: (text) => setState(() => _textEmail),
              ),
              PasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                errorText: _errorText,
                onChanged: (text) => setState(() => _textEmail),
              ),
              // button Next
              LargeButton(
                isOutlined: false,
                onPressed: signUpUser,
                text: "Next",
              ),

              BottomNavigator(
                content: 'Had an account?',
                nameScreenNavigator: SignInUpString.signin,
                handleNavigator: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

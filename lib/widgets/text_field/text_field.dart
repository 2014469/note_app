import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';

// ô nhập dữ liệu email
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? hintText;
  final Function(String)? onChanged;
  const InputField(
      {super.key,
      this.errorText,
      this.onChanged,
      this.hintText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
          helperText: " ",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? hintText;
  final Function(String)? onChanged;
  const PasswordField(
      {super.key,
      this.errorText,
      this.onChanged,
      this.hintText,
      required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHidePass = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: TextField(
        obscureText: _isHidePass,
        obscuringCharacter: "*",
        onChanged: widget.onChanged,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          errorText: widget.errorText,
          helperText: " ",
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isHidePass = !_isHidePass;
                });
              },
              icon: _isHidePass
                  ? Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColors.gray[60],
                    )
                  : Icon(
                      Icons.remove_red_eye_rounded,
                      color: AppColors.gray[60],
                    )),
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

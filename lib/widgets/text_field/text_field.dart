import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';

// ô nhập dữ liệu email
class InputField extends StatelessWidget {
  final String? defaultText;
  final TextEditingController controller;
  final String? errorText;
  final String? hintText;
  final String? helperText;
  final Function(String)? onChanged;
  final bool isEditing;
  final Color fillColor;
  const InputField({
    super.key,
    this.defaultText,
    this.errorText,
    this.onChanged,
    this.hintText,
    required this.controller,
    this.helperText = " ",
    this.isEditing = true,
    this.fillColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: TextField(
        enabled: isEditing,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          labelText: defaultText,
          hintText: hintText,
          errorText: errorText,
          helperText: helperText,
          filled: true,
          fillColor: fillColor,
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
  final String? helperText;
  final Function(String)? onChanged;
  const PasswordField({
    super.key,
    this.errorText,
    this.onChanged,
    this.hintText,
    required this.controller,
    this.helperText = " ",
  });

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
          helperText: widget.helperText,
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

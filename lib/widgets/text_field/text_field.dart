import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
// ô nhập dữ liệu email  
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final String hintText;
  const InputField(
      {super.key,
      this.errorText,
      this.hintText = "Text Field",
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: AppColors.gray[30]!, width: 1.h)),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: AppColors.gray[30]!, width: 1.h)),
            hintText: hintText,
            errorText: errorText,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w)),
           
      ),
    );
  }
}
// ô nhập password 
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  const PasswordField(
      {super.key,
      this.errorText,
      this.hintText = "Text Field",
      required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hiddenFlag = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Stack(children: [
        TextFormField(
          validator: (value) => "This is error",
          obscureText: hiddenFlag,
          controller: widget.controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide:
                      BorderSide(color: AppColors.gray[30]!, width: 1.h)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide:
                      BorderSide(color: AppColors.gray[30]!, width: 1.h)),
              hintText: widget.hintText,
              errorText: widget.errorText,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w)),
          //   validator: (value){
          //   if (value !=null && value.length<7){
          //     return 'enter min. 7 character';
          //   }else{
          //     return null;
          //   }
          //  }, 
        ),
        Positioned(
          height: 30.h,
          width: 30.w,
          right: 16.w,
          top: 12.h,
          child: InkWell(
            child:
                Image.asset(hiddenFlag ? AssetPaths.eyeHide : AssetPaths.eyeShow),
            onTap: () {
              setState(() {
                hiddenFlag = !hiddenFlag;
              });
            },
          ),
        )
      ]),
    );
  }
}

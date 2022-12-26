import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/screens/user_info/widgets/buttons.dart';

import '../../../widgets/bar/app_bar.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Delete account',
        isH5Title: true,
        handleBackBtn: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: ColorButton(
                isRounded: false,
                isOpacity: false,
                text: "Delete my Account Now",
                color: const Color(0xffF44B3D),
                onpressed: () {}),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_app/widgets/app_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Change your password",
        isH6Title: true,
        handleBackBtn: (() => Navigator.of(context).pop()),
      ),
      body: const Text("Change Password"),
    );
  }
}

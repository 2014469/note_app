import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:provider/provider.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({super.key});

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  late Timer timer;
  late User user;
  late bool _isEmailVerified;

  @override
  void initState() {
    super.initState();
    context.read<AuthService>().sendEmailVerification();

    user = context.read<AuthService>().getUser!;
    _isEmailVerified = user.emailVerified;

    if (!_isEmailVerified) {
      _startEmailVerificationTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  _startEmailVerificationTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer _) {
      user = context.read<AuthService>().reloadCurrentUser();
      if (user.emailVerified == true) {
        setState(() {
          _isEmailVerified = user.emailVerified;
        });
        timer.cancel();
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.authWrapper,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Check your email"),
      ),
    );
  }
}

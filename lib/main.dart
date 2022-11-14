import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/string_constant.dart';
import 'package:note_app/screens/checkmail.screen.dart';
import 'package:note_app/screens/error.screen.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/screens/loading.screen.dart';
import 'package:note_app/screens/splash.screen.dart';
import 'package:note_app/screens/login.screen.dart';
import 'package:note_app/screens/reset_password.screen.dart';
import 'package:note_app/screens/sign_up.screen.dart';
import 'package:note_app/screens/welcome.screen.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/auth/firebase_auth_provider.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// import 'package:provider/provider.dart';



class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return const LoadingScreen();
  }
}

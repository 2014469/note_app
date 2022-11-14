import 'package:flutter/material.dart';
import 'package:note_app/main.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/screens/info_user.screen.dart';
import 'package:note_app/screens/notes/list_note.screen.dart';
import 'package:note_app/screens/sign_in_up/login.screen.dart';
import 'package:note_app/screens/sign_in_up/sign_up.screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';
  static const String authWrapper = '/authwrapper';
  static const String notes = '/notes';
  static const String infoUser = '/infoUser';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => const LoginScreen(),
    home: (BuildContext context) => const HomeScreen(),
    signup: (BuildContext context) => const SignUpScreen(),
    authWrapper: (BuildContext context) => const AuthWrapper(),
    notes: (BuildContext context) => const NotesScreen(),
    infoUser: (BuildContext context) => const InfoUserScreen(),
  };
}

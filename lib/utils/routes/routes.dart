
import 'package:flutter/material.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/screens/login.screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String login = '/login';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => const LoginScreen(),
    home: (BuildContext context) => const HomeScreen(),
  };
}
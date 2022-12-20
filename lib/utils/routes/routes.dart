import 'package:flutter/material.dart';
import 'package:note_app/main.dart';
import 'package:note_app/screens/change_password.screen.dart';
import 'package:note_app/screens/delete_account.screen.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/screens/info_user.screen.dart';
import 'package:note_app/screens/sign_in_up/login.screen.dart';
import 'package:note_app/screens/sign_in_up/sign_up.screen.dart';

import '../../screens/notes/edit/edit_note.screen.dart';
import '../../screens/notes/notes_list/notes.screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';
  static const String authWrapper = '/authwrapper';
  static const String notes = '/notes';
  static const String infoUser = '/infoUser';
  static const String editNote = '/editNote';
  static const String changePassword = '/changePassword';
  static const String deleteAccount = '/deleteAccount';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => const LoginScreen(),
    home: (BuildContext context) => const HomeScreen(),
    signup: (BuildContext context) => const SignUpScreen(),
    authWrapper: (BuildContext context) => const AuthWrapper(),
    notes: (BuildContext context) => const NotesScreen(),
    infoUser: (BuildContext context) => const InfoUserScreen(),
    editNote: (BuildContext context) => const EditNoteScreen(),
    changePassword: (BuildContext context) => const ChangePasswordScreen(),
    deleteAccount: (BuildContext context) => const DeleteAccountScreen(),
  };
}

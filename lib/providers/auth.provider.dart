import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/auth_user.dart';

class AuthProvider extends ChangeNotifier {
  late final AuthUser _authUser;

  AuthUser get authUser => _authUser;

  void setInfoUser(User user) {
    _authUser = AuthUser.fromFirebaseWithInformation(user);
    notifyListeners();
  }
}

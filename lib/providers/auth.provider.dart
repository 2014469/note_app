import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/auth_user.dart';

import '../resources/constants/str_user.dart';

class UserProvider extends ChangeNotifier {
  AuthUser? currentUser;

  AuthUser get getCurrentUser {
    return currentUser ?? AuthUser.nullValue();
  }

  void setInfoUser() {
    currentUser = AuthUser.fromFirebaseWithInformation(
        FirebaseAuth.instance.currentUser!);
    notifyListeners();
  }

  void addUser({required AuthUser user}) async {
    await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(user.uID)
        .set(user.toDynamic());
  }

  void updateUser({required AuthUser user}) async {
    await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(user.toDynamic());
    user = user;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    log("Fetch user");
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    log(snapshot.data().toString());
    currentUser = AuthUser.fromSnapshot(snapshot);
    currentUser!.printInfo();
    notifyListeners();
  }

  void deleteUser({required String uId}) async {
    await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(uId)
        .delete();
  }
}

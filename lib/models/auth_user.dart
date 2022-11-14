import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:note_app/resources/constants/str_user.dart';
import 'package:note_app/utils/customLog/debug_log.dart';
import 'package:uuid/uuid.dart';

class AuthUser extends ChangeNotifier {
  String? id;
  String? uID;
  String? displayName;
  String? fullName;
  String? email;
  String? photoUrl;

  AuthUser({
    this.id,
    this.uID,
    this.displayName,
    this.fullName,
    this.email,
    this.photoUrl,
  });

  factory AuthUser.fromFirebaseWithInformation(User user) => AuthUser(
        id: const Uuid().v1(),
        uID: user.uid,
        displayName: user.displayName ?? "",
        fullName: "",
        email: user.email,
        photoUrl: user.photoURL ??
            "https://images.unsplash.com/photo-1645680827507-9f392edae51c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80",
      );

  factory AuthUser.fromSnapshot(DocumentSnapshot snapshot) {
    return AuthUser.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  factory AuthUser.fromJson(Map<String, dynamic> reponseData) {
    return AuthUser(
      id: reponseData[UserString.id],
      uID: reponseData[UserString.uId],
      displayName: reponseData[UserString.displayName],
      fullName: reponseData[UserString.displayName],
      email: reponseData[UserString.email],
      photoUrl: reponseData[UserString.photoUrl],
    );
  }

  Map<String, dynamic> toDynamic() {
    return {
      UserString.id: id,
      UserString.uId: uID,
      UserString.displayName: displayName,
      UserString.fullName: fullName,
      UserString.email: email,
      UserString.photoUrl: photoUrl,
    };
  }

  void printInfo() {
    DebugLog.myLog(
      "${id.toString()}|\t",
    );

    DebugLog.myLog(
      "${uID.toString()}|\t",
    );

    DebugLog.myLog(
      "${displayName.toString()}|\t",
    );
    DebugLog.myLog(
      "${fullName.toString()}|\t",
    );

    DebugLog.myLog(
      "${email.toString()}|\t",
    );

    DebugLog.myLog(
      "${photoUrl.toString()}|\t",
    );
  }
}

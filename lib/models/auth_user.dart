import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:note_app/resources/constants/str_user.dart';
import 'package:note_app/utils/customLog/debug_log.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'auth_user.g.dart';

@HiveType(typeId: 0)
class AuthUser {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? uID;

  @HiveField(2)
  String? displayName;

  @HiveField(3)
  String? fullName;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? photoUrl;

  AuthUser({
    this.id,
    this.uID,
    this.displayName = "User",
    this.fullName,
    this.email,
    this.photoUrl,
  });

  AuthUser.nullValue()
      : id = "",
        uID = "",
        displayName = "User Name",
        fullName = "",
        email = "",
        photoUrl =
            "https://firebasestorage.googleapis.com/v0/b/note-app-e936e.appspot.com/o/Logo.png?alt=media&token=090610fc-252a-4706-b128-b43fec21720b";

  factory AuthUser.fromFirebaseWithInformation(User user) => AuthUser(
        id: const Uuid().v1(),
        uID: user.uid,
        displayName: user.displayName ?? "User",
        fullName: "",
        email: user.email,
        photoUrl: user.photoURL ??
            "https://firebasestorage.googleapis.com/v0/b/note-app-e936e.appspot.com/o/Logo.png?alt=media&token=090610fc-252a-4706-b128-b43fec21720b",
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

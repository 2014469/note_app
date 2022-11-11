import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:uuid/uuid.dart';

class AuthUser {
  final bool isEmailVerified;
  String? id;
  String? uID;
  String? displayName;
  String? fullName;
  String? email;
  String? photoUrl;

  AuthUser(this.isEmailVerified);

  AuthUser.emailVerified({
    this.id,
    this.uID,
    this.displayName,
    this.fullName,
    this.email,
    this.photoUrl,
  }) : isEmailVerified = true;

  factory AuthUser.fromFirebaseWithVerifiedEmail(User user) =>
      AuthUser(user.emailVerified);

  factory AuthUser.fromFirebaseWithInformation(User user) =>
      AuthUser.emailVerified(
        id: const Uuid().v1(),
        uID: user.uid,
        displayName: user.displayName ?? "",
        fullName: "",
        email: user.email,
        photoUrl:
            user.photoURL ?? "https://api.unsplash.com/photos/iulnjpZyWnc",
      );
}

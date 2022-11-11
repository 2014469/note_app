import 'package:note_app/resources/constants/str_user.dart';
import 'package:uuid/uuid.dart';

class MyUser {
  String? id;
  String? uID;
  String? displayName;
  String? fullName;
  String? email;
  String? photoUrl;

  MyUser({
    this.uID,
    this.displayName,
    this.fullName,
    this.email,
    this.photoUrl,
  }) : id = const Uuid().v1();

  // factory MyUser.fromFirebase(User user) => MyUser(
  // uID: user.uid, displayName: user.displayName ?? "",

  // )

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
}

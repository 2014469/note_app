import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/user.dart';
import 'package:note_app/resources/constants/str_user.dart';

class UserAction {
  Future addUser({required MyUser user}) async {
    return await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .add(user.toDynamic());
  }

  Future getUser() async {}
}

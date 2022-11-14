import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/resources/constants/str_user.dart';

import '../../utils/customLog/debug_log.dart';

class UserAction {
  final _instance = FirebaseFirestore.instance;
  Future addUser({required AuthUser user}) async {
    return await _instance
        .collection(UserString.userTBL)
        .doc(user.uID)
        .set(user.toDynamic());
  }

  Future<AuthUser> fetchUser({required String uId}) async {
    DocumentSnapshot snapshot =
        await _instance.collection(UserString.userTBL).doc(uId).get();
    DebugLog.myLog(snapshot.data().toString());
    AuthUser result = AuthUser.fromSnapshot(snapshot);
    result.printInfo();
    return result;
  }

  Future<void> deleteUser({required String uId}) {
    return _instance.collection(UserString.userTBL).doc(uId).delete();
  }

  Future<bool> userExists(String uId) async {
    return await _instance
        .collection(UserString.userTBL)
        .where(UserString.uId, isEqualTo: uId)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }
}

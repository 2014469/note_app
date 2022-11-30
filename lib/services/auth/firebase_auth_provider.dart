import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/services/auth/auth_exceptions.dart';
import 'package:note_app/services/auth/auth_provider.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/services/user/user_action.dart';
import 'package:note_app/utils/customLog/debug_log.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser?> get currentUser async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      bool isUserExist = await UserAction().userExists(uid);
      AuthUser authUser;
      if (isUserExist) {
        return await UserAction().fetchUser(uId: uid);
      } else {
        authUser = AuthUser.fromFirebaseWithInformation(user);
        await UserAction().addUser(user: authUser);
        authUser.printInfo();
        return authUser;
      }
    } else {
      return null;
    }
  }

  @override
  User? get getUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

  @override
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await UserAction()
          .deleteUser(uId: FirebaseAuth.instance.currentUser!.uid);
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> logOUt() async {
    final user = FirebaseAuth.instance.currentUser;
    DebugLog.myLog(user?.uid.toString() ?? "Null uid");
    DebugLog.myLog(user?.email.toString() ?? "Null email");
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> loginEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseException catch (e) {
      DebugLog.myLog(e.toString());
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    // AuthUser authUser;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        DebugLog.myLog("Dang nhap");

        await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw GoogleSignInAccountException();
      }
    } catch (e) {
      DebugLog.myLog(e.toString());

      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> signUpEmailPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        user.updateDisplayName(username);
        return;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  User reloadCurrentUser() {
    User oldUser = FirebaseAuth.instance.currentUser!;
    oldUser.reload();
    User newUser = FirebaseAuth.instance.currentUser!;
    return newUser;
  }

  @override
  bool get authIsVerifiedEmail {
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }
}

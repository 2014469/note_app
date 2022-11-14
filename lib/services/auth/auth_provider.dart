import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/models/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  Future<AuthUser?> get currentUser;
  User? get getUser;

  Stream<User?> get authState;
  bool get authIsVerifiedEmail;

  User reloadCurrentUser();

  Future<void> loginEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signUpEmailPassword({
    required String username,
    required String email,
    required String password,
  });

  Future<void> loginWithGoogle();
  Future<void> logOUt();
  Future<void> sendEmailVerification();
  Future<void> deleteAccount();
}

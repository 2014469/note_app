import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/models/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Stream<User?> get authState;

  Future<AuthUser> loginEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> signUpEmailPassword({
    required String username,
    required String email,
    required String password,
  });

  Future<AuthUser> loginWithGoogle();
  Future<void> logOUt();
  Future<void> sendEmailVerification();
  Future<void> deleteAccount();
}

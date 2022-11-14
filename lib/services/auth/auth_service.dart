import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/services/auth/auth_provider.dart';

import 'package:note_app/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Stream<User?> get authState => provider.authState;

  @override
  Future<AuthUser?> get currentUser => provider.currentUser;

  @override
  Future<void> deleteAccount() => provider.deleteAccount();

  @override
  Future<void> logOUt() => provider.logOUt();

  @override
  Future<void> loginEmailPassword({
    required String email,
    required String password,
  }) =>
      provider.loginEmailPassword(
        email: email,
        password: password,
      );

  @override
  Future<void> loginWithGoogle() => provider.loginWithGoogle();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> signUpEmailPassword({
    required String username,
    required String email,
    required String password,
  }) =>
      provider.signUpEmailPassword(
        username: username,
        email: email,
        password: password,
      );

  @override
  User reloadCurrentUser() => provider.reloadCurrentUser();

  @override
  User? get getUser => provider.getUser;

  @override
  bool get authIsVerifiedEmail => provider.authIsVerifiedEmail;
//   @override
//   Future<AuthUser> resetPassword({
//     required String password,
//     required String confirmpassword,
//   }) =>
//       provider.resetPassword(
//         password: password,
//         confirmpassword: confirmpassword,
//       );
}

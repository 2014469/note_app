import 'package:note_app/utils/validate/extension_validate.dart';

String? checkEmail(String textEmail) {
  String email = textEmail.trim();
  if (email.isEmpty) {
    return "Can't be empty";
  } else if (!email.isValidEmail()) {
    return "Email invalid";
  }

  return null;
}

String? checkPassword(String pass) {
  String password = pass.trim();

  if (password.isEmpty) {
    return "Can't be empty";
  } else if (password.length < 6) {
    return "Must be 6 characters";
  }
  return null;
}

String? checkStrengthPassword(String pass) {
  String password = pass.trim();
  if (password.length < 6) {
    return "Weak";
  } else if (password.length < 8) {
    return "Medium";
  } else {
    if (password.isPassGood()) {
      return "Good";
    } else {
      return "Strong";
    }
  }
}

String? checkPasswordConfirmMatch(String pass, String passConfirm) {
  String password = pass.trim();
  String passwordConfirm = passConfirm.trim();

  if (passwordConfirm.isEmpty) {
    return "Can't be empty";
  } else if (passwordConfirm != password) {
    return "Not match";
  }
  return null;
}

//create error exception in your app
//login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

// google signin

class GoogleSignInAccountException implements Exception {}

// change password

class WrongOldPassWord implements Exception {}

class ErrorChangePassword implements Exception {}

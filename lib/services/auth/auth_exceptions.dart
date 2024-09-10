// register exceptions
class InvalidEmailAuthException implements Exception {}

class WeakPassordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}

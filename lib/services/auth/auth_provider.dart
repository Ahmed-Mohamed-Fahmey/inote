import 'package:inote/services/auth/auth_user.dart';

// this is an interface for any auth provider used in the application
abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUSer({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}

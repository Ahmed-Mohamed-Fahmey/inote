import 'package:inote/services/auth/auth_provider.dart';
import 'package:inote/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> createUSer({
    required String email,
    required String password,
  }) =>
      provider.createUSer(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}

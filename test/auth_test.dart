import 'package:inote/services/auth/auth_exceptions.dart';
import 'package:inote/services/auth/auth_provider.dart';
import 'package:inote/services/auth/auth_user.dart';
import 'package:test/test.dart';

main() {
  group('Mock AuthProvider test:', () {
    // All mockAuth tests inside this group
    final provider = MockAuthProvider();

    test('Not yet initialized', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    //able to init
    // user isNull after init
    test('Should be able to Initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('Empty user after init', () {
      expect(provider.currentUser, null);
    });

    // aync testing
    test(
      'Initialization in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    //test create user and login
    test('Create user is in line with LogIn function', () async {
      final badEmailUser = provider.createUSer(
        email: 'foo@bar.com',
        password: 'password',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUSer(
        email: 'email',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final goodUser = await provider.createUSer(
        email: 'foo',
        password: 'bar',
      );
      // expecting providers current user is now our goodUser
      // and it is not yet verifies after creation
      expect(provider.currentUser, goodUser);
      expect(goodUser.isEmailVerified, false);
    });

    test('Able to get Verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Able to logout and login again', () async {
      await provider.logOut();
      expect(provider.currentUser, isNull);

      await provider.logIn(email: 'email', password: 'password');
      expect(provider.currentUser, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // what register does is:
  // first ensure that servise is initialized
  // talk with backend
  // add user there
  // login user
  // return user
  @override
  Future<AuthUser> createUSer({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  //ensure init
  // take email and pass
  // check if they meet requirements
  // check if exist in database
  // set user
  // return him
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  // ensure init
  // ensure logged in (ther is a user)
  // wait
  // make user null
  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  // isInit
  // isLoggedIn
  // fake wait
  // create new user with verified email
  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    await Future.delayed(const Duration(seconds: 1));
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}

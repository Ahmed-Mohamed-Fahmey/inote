import 'package:flutter/material.dart';
import 'package:inote/constants/routes.dart';
import 'package:inote/services/auth/auth_exceptions.dart';
import 'package:inote/services/auth/auth_service.dart';
import 'package:inote/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'email'),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                // create user
                await AuthService.firebase().createUSer(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                // push verifyEmailView on top
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on InvalidEmailAuthException {
                await showErrorMessage(
                  context,
                  'Invalid email address',
                );
              } on WeakPasswordAuthException {
                await showErrorMessage(
                  context,
                  "Password is too weak",
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorMessage(
                  context,
                  'Email is already in use',
                );
              } on UserNotLoggedInException {
                await showErrorMessage(
                  context,
                  'User not logged in',
                );
              } on GenericAuthException {
                await showErrorMessage(
                  context,
                  'Failed to register',
                );
              }
            },
            child: const Text('register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already registerd? Login'))
        ],
      ),
    );
  }
}

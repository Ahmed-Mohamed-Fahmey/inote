import 'package:flutter/material.dart';
import 'package:inote/constants/routes.dart';
import 'package:inote/services/auth/auth_exceptions.dart';
import 'package:inote/services/auth/auth_service.dart';
import 'package:inote/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                final user = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                // after succeful login check if email is vreified
                if (user.isEmailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on InvalidEmailAuthException {
                await showErrorMessage(
                  context,
                  'Wrong email',
                );
              } on UserNotFoundAuthException {
                await showErrorMessage(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorMessage(
                  context,
                  'wrong credintials',
                );
              } on GenericAuthException {
                await showErrorMessage(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text('login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet, Register'))
        ],
      ),
    );
  }
}

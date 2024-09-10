import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inote/constants/routes.dart';
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // send email verification after succeful registration
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                // push verifyEmailView on top
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  await showErrorMessage(
                    context,
                    'Invalid email address',
                  );
                } else if (e.code == 'weak-password') {
                  await showErrorMessage(
                    context,
                    "Password is too weak",
                  );
                } else if (e.code == 'email-already-in-use') {
                  await showErrorMessage(
                    context,
                    'Email is already in use',
                  );
                } else {
                  await showErrorMessage(
                    context,
                    'Error: ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorMessage(
                  context,
                  e.toString(),
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

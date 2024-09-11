import 'package:flutter/material.dart';
import 'package:inote/constants/routes.dart';
import 'package:inote/enums/menu_action.dart';
import 'package:inote/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  devtools.log(value.toString());
                  final shouldLogOut = await showLogoutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  devtools.log(shouldLogOut.toString());
                  break;
                case MenuAction.settings:
                  devtools.log(value.toString());
                  final shouldOpenSettings = await showSettingsDialog(context);
                  devtools.log(shouldOpenSettings.toString());
                  devtools.log('no settings yet');
                  break;
                default:
                  devtools.log('default');
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('log out'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text('settings'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogoutDialog(context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => (value) ?? false);
}

Future<bool> showSettingsDialog(context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Settings'),
      content: const Text('Are you sure you want to open settings?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Open settings'),
        )
      ],
    ),
  ).then((value) => (value) ?? false);
}

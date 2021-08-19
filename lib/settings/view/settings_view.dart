import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/settings/view/theme_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return SettingsView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings bar'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.of(context).push(ProfileSettingsView.route(context));
            },
          ),
          ListTile(
            title: const Text('Theme'),
            leading: const Icon(Icons.brush),
            onTap: () {
              Navigator.of(context).push(ThemeSettingsView.route(context));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}

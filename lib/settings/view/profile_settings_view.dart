import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute rout(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return BlocProvider(
          create: (context) => ProfileSettingsBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
          child: Container(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
    );
  }
}

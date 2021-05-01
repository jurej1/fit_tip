import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication.dart';

class Home extends StatelessWidget {
  static const routeName = 'home_route';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text('Logout'),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}

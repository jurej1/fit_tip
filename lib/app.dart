import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
        ),
      ],
      child: MaterialApp(),
    );
  }
}

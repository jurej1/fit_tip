import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const App({Key? key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'FitTip',
          home: RegisterView(),
          routes: {
            RegisterView.routeName: (BuildContext context) => RegisterView(),
            LoginView.routeName: (BuildContext context) => LoginView(),
          },
        ),
      ),
    );
  }
}

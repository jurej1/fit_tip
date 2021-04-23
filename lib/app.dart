import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  App({Key? key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(key: key);

  final _navigatorState = GlobalKey<NavigatorState>();

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
            lazy: false,
            create: (context) => AuthenticationBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
          ),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorState,
          title: 'FitTip',
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state.status == AuthenticationStatus.unauthenticated) {
                  _navigatorState.currentState!.pushReplacementNamed(LoginView.routeName);
                } else if (state.status == AuthenticationStatus.authenticated) {
                  _navigatorState.currentState!.pushReplacementNamed(Home.routeName);
                }
              },
              child: child,
            );
          },
          home: _SplashScreen(),
          routes: {
            RegisterView.routeName: (BuildContext context) {
              return BlocProvider<RegisterFormBloc>(
                create: (context) => RegisterFormBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
                child: RegisterView(),
              );
            },
            LoginView.routeName: (BuildContext context) {
              return BlocProvider<LoginFormBloc>(
                create: (context) => LoginFormBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context)),
                child: LoginView(),
              );
            },
            Home.routeName: (BuildContext context) => Home(),
          },
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

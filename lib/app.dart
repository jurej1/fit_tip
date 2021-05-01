import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_repository/weight_repository.dart';

import 'authentication/authentication.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final WeightRepository _weightRepository;

  App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required WeightRepository weightRepository,
  })   : _authenticationRepository = authenticationRepository,
        _weightRepository = weightRepository,
        super(key: key);

  final _navigatorState = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _weightRepository),
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
              listenWhen: (previous, current) => previous.status != current.status,
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

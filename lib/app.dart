import 'package:authentication_repository/authentication_repository.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:water_repository/water_repository.dart';
import 'package:weight_repository/weight_repository.dart';

import 'authentication/authentication.dart';
import 'birthday/birthday.dart';
import 'home/home.dart';
import 'settings/settings.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final WeightRepository _weightRepository;
  final WaterRepository _waterRepository;
  final FoodRepository _foodRepository;
  final FitnessRepository _fitnessRepository;

  App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required WeightRepository weightRepository,
    required WaterRepository waterRepository,
    required FoodRepository foodRepository,
    required FitnessRepository fitnessRepository,
  })  : _authenticationRepository = authenticationRepository,
        _waterRepository = waterRepository,
        _weightRepository = weightRepository,
        _foodRepository = foodRepository,
        _fitnessRepository = fitnessRepository,
        super(key: key);

  final _navigatorState = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _weightRepository),
        RepositoryProvider.value(value: _waterRepository),
        RepositoryProvider.value(value: _foodRepository),
        RepositoryProvider.value(value: _fitnessRepository)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            lazy: false,
            create: (context) => AuthenticationBloc(
              authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            ),
          ),
          BlocProvider<MeasurmentSystemBloc>(
            create: (context) => MeasurmentSystemBloc(),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => BirthdayMessengerBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            ),
          )
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: _navigatorState,
              title: 'FitTip',
              themeMode: state.themeMode,
              darkTheme: ThemeData.dark(),
              theme: ThemeData(
                primaryColor: state.accentColor,
                snackBarTheme: SnackBarThemeData(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              builder: (context, child) {
                return MultiBlocListener(
                  listeners: [
                    BlocListener<AuthenticationBloc, AuthenticationState>(
                      listenWhen: (previous, current) => previous.status != current.status,
                      listener: (context, state) {
                        if (state.status == AuthenticationStatus.unauthenticated) {
                          _navigatorState.currentState!.pushReplacement(LoginView.route(context));
                        } else if (state.status == AuthenticationStatus.authenticated) {
                          _navigatorState.currentState!.pushReplacement(HomeView.route(context));
                        }
                      },
                    ),
                    BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        BlocProvider.of<MeasurmentSystemBloc>(context).add(MeasurmentSystemUpdated(system: state.user?.measurmentSystem));
                      },
                    ),
                  ],
                  child: child!,
                );
              },
              home: _SplashScreen(),
            );
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

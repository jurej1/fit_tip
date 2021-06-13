import 'package:authentication_repository/authentication_repository.dart';
import 'package:fit_tip/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:water_repository/water_repository.dart';
import 'package:weight_repository/weight_repository.dart';

import 'authentication/authentication.dart';
import 'weight_tracking/weight.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final WeightRepository _weightRepository;
  final WaterRepository _waterRepository;
  final FoodRepository _foodRepository;

  App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required WeightRepository weightRepository,
    required WaterRepository waterRepository,
    required FoodRepository foodRepository,
  })   : _authenticationRepository = authenticationRepository,
        _waterRepository = waterRepository,
        _weightRepository = weightRepository,
        _foodRepository = foodRepository,
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
          BlocProvider<WeightHistoryBloc>(
            create: (context) => WeightHistoryBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              weightRepository: RepositoryProvider.of<WeightRepository>(context),
            ),
          ),
          BlocProvider<WeightGoalBloc>(
            create: (context) => WeightGoalBloc(
              weightRepository: RepositoryProvider.of<WeightRepository>(context),
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            ),
          )
        ],
        child: MaterialApp(
          navigatorKey: _navigatorState,
          title: 'FitTip',
          theme: ThemeData(
            primaryColor: Colors.blue[900],
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
                      _navigatorState.currentState!.pushReplacement(Home.route(context));
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

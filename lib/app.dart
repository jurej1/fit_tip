import 'package:authentication_repository/authentication_repository.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:water_repository/water_repository.dart';
import 'package:weight_repository/weight_repository.dart';

import 'authentication/authentication.dart';
import 'birthday/birthday.dart';
import 'home/home.dart';
import 'settings/settings.dart';

class App extends StatefulWidget {
  final AuthenticationRepository _authenticationRepository;
  final WeightRepository _weightRepository;
  final WaterRepository _waterRepository;
  final FoodRepository _foodRepository;
  final FitnessRepository _fitnessRepository;
  final BlogRepository _blogRepository;

  App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required WeightRepository weightRepository,
    required WaterRepository waterRepository,
    required FoodRepository foodRepository,
    required FitnessRepository fitnessRepository,
    required BlogRepository blogRepository,
  })  : _authenticationRepository = authenticationRepository,
        _waterRepository = waterRepository,
        _weightRepository = weightRepository,
        _foodRepository = foodRepository,
        _fitnessRepository = fitnessRepository,
        _blogRepository = blogRepository,
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorState = GlobalKey<NavigatorState>();

  @override
  Future<void> dispose() async {
    await Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget._authenticationRepository),
        RepositoryProvider.value(value: widget._weightRepository),
        RepositoryProvider.value(value: widget._waterRepository),
        RepositoryProvider.value(value: widget._foodRepository),
        RepositoryProvider.value(value: widget._fitnessRepository),
        RepositoryProvider.value(value: widget._blogRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            lazy: false,
            create: (context) => AuthenticationBloc(
              authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => UserDataBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
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
              userDataBloc: BlocProvider.of<UserDataBloc>(context),
            ),
          )
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: _navigatorState,
              debugShowCheckedModeBanner: false,
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
                    BlocListener<UserDataBloc, UserDataState>(
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

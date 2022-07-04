import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FitnessTrackingView extends StatelessWidget {
  const FitnessTrackingView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return widget(context);
      },
    );
  }

  static Widget widget(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FitnessTrackingViewCubit(),
        ),
        BlocProvider(
          create: (context) => ActiveWorkoutViewSelectorCubit(),
        ),
        BlocProvider(
          create: (context) => ActiveWorkoutBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => WorkoutDayLogsBloc(
            activeWorkoutBloc: BlocProvider.of<ActiveWorkoutBloc>(context),
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          )..add(WorkoutDayLogsLoadRequested()),
        ),
        BlocProvider(
          create: (context) => ActiveWorkoutsHistoryListBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          )..add(ActiveWorkoutsHistoryListLoadRequested()),
        )
      ],
      child: FitnessTrackingView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessTrackingViewCubit, FitnessTrackingWorkoutPage>(
      builder: (context, page) {
        return _body(page);
      },
    );
  }

  Widget _body(FitnessTrackingWorkoutPage page) {
    if (page.isActive) {
      return ActiveWorkoutBuilder.route();
    }

    if (page.isAllActive) {
      return ActiveWorkoutsHistoryBuilder();
    }

    return Container();
  }
}

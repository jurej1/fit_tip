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
          create: (context) => WorkoutsListBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
          )..add(WorkoutsListLoadRequested()),
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
    if (page == FitnessTrackingWorkoutPage.active) {
      return ActiveWorkoutBuilder.route();
    }
    if (page == FitnessTrackingWorkoutPage.all) {
      return WorkoutsListBuilder();
    }

    return Container();
  }
}

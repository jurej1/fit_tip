import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RunningWorkoutDayView extends StatelessWidget {
  const RunningWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(WorkoutDay workoutDay) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => RunningWorkoutDayBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
            workoutDay: workoutDay,
          ),
          child: Container(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running workout view'),
      ),
    );
  }
}

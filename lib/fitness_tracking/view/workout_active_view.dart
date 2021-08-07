import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutActiveView extends StatelessWidget {
  const WorkoutActiveView({Key? key}) : super(key: key);

  static MaterialPageRoute route(WorkoutDay workoutDay) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => WorkoutActiveBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            fitnessRepository: RepositoryProvider.of<FitnessRepository>(context),
            workoutDay: workoutDay,
          ),
          child: WorkoutActiveView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout active view'),
      ),
    );
  }
}

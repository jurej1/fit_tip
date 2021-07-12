import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutDayView extends StatelessWidget {
  const AddWorkoutDayView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context, {required WorkoutDay workoutDay}) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddWorkoutDayFormBloc(workoutDay: workoutDay),
            ),
          ],
          child: const AddWorkoutDayView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add workout day'),
      ),
    );
  }
}

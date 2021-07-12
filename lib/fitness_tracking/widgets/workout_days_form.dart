import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutDaysForm extends StatelessWidget {
  const WorkoutDaysForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            return Container(
              height: 30,
              color: Colors.blue,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15,
            );
          },
          itemCount: state.workoutDaysLenght,
        );
      },
    );
  }
}

class WorkoutDayCard extends StatelessWidget {
  const WorkoutDayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}

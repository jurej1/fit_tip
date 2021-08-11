import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutExcerciseCard extends StatelessWidget {
  const WorkoutExcerciseCard({Key? key}) : super(key: key);

  static Widget provider(WorkoutExcercise excercise) {
    return BlocProvider(
      create: (context) => WorkoutExcerciseCardBloc(excercise: excercise),
      child: WorkoutExcerciseCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutExcerciseCardBloc, WorkoutExcerciseCardState>(
      builder: (context, state) {
        return Material(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(state.excercise.name),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class ActiveWorkoutOverviewBuilder extends StatelessWidget {
  const ActiveWorkoutOverviewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoadSuccess) {
          return ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              WorkoutInfoRow(
                created: state.workout.info.mapCreatedToText,
                daysPerWeek: state.workout.info.daysPerWeek.toStringAsFixed(0),
                goal: state.workout.info.goal != null ? state.workout.info.goal!.toStringReadable() : '',
              ),
              if (state.workout.info.note != null) ...{
                Text(
                  'Info',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(state.workout.info.note!),
                const SizedBox(height: 10),
              },
              ...state.workout.workoutDays!.workoutDays
                  .map(
                    (e) => Column(
                      children: [
                        WorkoutDetailItem(workout: e),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                  .toList(),
            ],
          );
        }
        return Container();
      },
    );
  }
}

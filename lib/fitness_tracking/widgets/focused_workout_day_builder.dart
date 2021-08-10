import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class FocusedWorkoutDayBuilder extends StatelessWidget {
  const FocusedWorkoutDayBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusedWorkoutDayBloc, FocusedWorkoutDayState>(
      builder: (context, state) {
        if (state is FocusedWorkoutDayLoading) {
          return SizedBox(
            height: 5,
            child: LinearProgressIndicator(),
          );
        } else if (state is FocusedWorkoutDayLoadSuccess) {
          final WorkoutDay? workoutDay = state.workoutDay;

          if (workoutDay == null) {
            return Container(
              child: Text(
                'No workout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (workoutDay.musclesTargeted != null && workoutDay.musclesTargeted!.isNotEmpty) ...{
                  Text(
                    'Muscles targeted',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  ...workoutDay.musclesTargeted!
                      .map(
                        (e) => Chip(
                          backgroundColor: Colors.blue.shade300,
                          label: Text(mapMuscleGroupToString(e)),
                          labelStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
                }
              ],
            ),
          );
        } else if (state is FocusedWorkoutDayFail) {
          return Container(
            child: Text('Sorry there was an error'),
          );
        }

        return Container();
      },
    );
  }
}

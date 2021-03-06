import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class FocusedWorkoutDayBuilder extends StatelessWidget {
  FocusedWorkoutDayBuilder({Key? key}) : super(key: key);

  final _titleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

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
                if (workoutDay.muscles != null && workoutDay.muscles!.isNotEmpty) _buildMuscleTargeted(workoutDay),
                if (workoutDay.note != null) _buildNote(workoutDay),
                _buildWorkoutTitle(workoutDay),
                const SizedBox(height: 10),
                ...state.workoutDayLog.map(
                  (e) {
                    return WorkoutExcercisesList(
                      excercises: e.excercises!,
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                    );
                  },
                ).toList(),
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

  Widget _buildWorkoutTitle(WorkoutDay workoutDay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Excercises',
          style: _titleStyle,
        ),
        Text(
          '${workoutDay.numberOfExcercises}',
          style: _titleStyle,
        )
      ],
    );
  }

  Widget _buildMuscleTargeted(WorkoutDay workoutDay) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Muscles targeted', style: _titleStyle), Text('${workoutDay.numberOfMusclesTargeted}', style: _titleStyle)],
        ),
        Wrap(
          spacing: 10,
          children: workoutDay.muscles!
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
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNote(WorkoutDay workoutDay) {
    return Column(
      children: [
        Text('Note', style: _titleStyle),
        Text(
          workoutDay.note!,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

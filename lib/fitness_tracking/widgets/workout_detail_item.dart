import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class WorkoutDetailItem extends StatelessWidget {
  const WorkoutDetailItem({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final WorkoutDay workout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (workout.excercises.isNotEmpty) Text(workout.mapDayToText),
        if (workout.musclesTargeted != null)
          ...workout.musclesTargeted!
              .map(
                (e) => Chip(
                  label: Text(mapMuscleGroupToString(e)),
                ),
              )
              .toList(),
        if (workout.excercises.isNotEmpty) ...{
          Row(
            children: [
              WorkoutExcerciseRowData(
                text: 'Name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              WorkoutExcerciseRowData(
                text: 'Sets',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              WorkoutExcerciseRowData(
                text: 'Reps',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        },
        ...workout.excercises.map((e) {
          return Row(
            children: [
              WorkoutExcerciseRowData(text: e.name),
              WorkoutExcerciseRowData(text: e.setsString),
              WorkoutExcerciseRowData(text: e.repsString),
            ],
          );
        }).toList(),
      ],
    );
  }
}

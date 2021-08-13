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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.mapDayToText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (workout.musclesTargeted != null) ...{
            SizedBox(height: 5),
            Container(
              height: 1.5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.black26,
            ),
            ...workout.musclesTargeted!
                .map(
                  (e) => Chip(
                    label: Text(
                      mapMuscleGroupToString(e),
                      style: TextStyle(color: Colors.grey.shade100),
                    ),
                    backgroundColor: Colors.blueAccent.shade100,
                  ),
                )
                .toList(),
          },
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
            SizedBox(height: 5),
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
      ),
    );
  }
}

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';

import '../fitness_tracking.dart';

class WorkoutExcercisesList extends StatelessWidget {
  const WorkoutExcercisesList({
    Key? key,
    this.excercises = const [],
    this.scrollPhysics = const ClampingScrollPhysics(),
  }) : super(key: key);

  final List<WorkoutExcercise> excercises;
  final ScrollPhysics scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: scrollPhysics,
      itemCount: excercises.length,
      itemBuilder: (context, index) {
        final item = excercises[index];
        return WorkoutExcerciseCard.provider(item);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }
}

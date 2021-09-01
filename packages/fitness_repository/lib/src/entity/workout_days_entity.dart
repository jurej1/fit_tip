import 'package:equatable/equatable.dart';

import 'entity.dart';

class WorkoutDaysEntity extends Equatable {
  final List<WorkoutDayEntity> workoutDays;
  final String workoutId;

  const WorkoutDaysEntity({
    this.workoutDays = const [],
    required this.workoutId,
  });

  @override
  List<Object> get props => [workoutDays, workoutId];

  WorkoutDaysEntity copyWith({
    List<WorkoutDayEntity>? workoutDays,
    String? workoutId,
  }) {
    return WorkoutDaysEntity(
      workoutDays: workoutDays ?? this.workoutDays,
      workoutId: workoutId ?? this.workoutId,
    );
  }
}

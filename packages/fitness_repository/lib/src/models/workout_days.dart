import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/workout_days_entity.dart';

class WorkoutDays extends Equatable {
  final List<WorkoutDay> workoutDays;
  final String workoutId;

  WorkoutDays({
    this.workoutDays = const [],
    required this.workoutId,
  });
  @override
  List<Object> get props => [workoutDays, workoutId];

  WorkoutDays copyWith({
    List<WorkoutDay>? workoutDays,
    String? workoutId,
  }) {
    return WorkoutDays(
      workoutDays: workoutDays ?? this.workoutDays,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  WorkoutDaysEntity toEntity() {
    return WorkoutDaysEntity(
      workoutId: workoutId,
      workoutDays: this.workoutDays?.map((e) => e.toEntity()).toList() ?? null,
    );
  }

  static WorkoutDays fromEntity(WorkoutDaysEntity entity) {
    return WorkoutDays(
      workoutId: entity.workoutId,
      workoutDays: entity.workoutDays?.map((e) => WorkoutDay.fromEntity(e)).toList() ?? [],
    );
  }
}
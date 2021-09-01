import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

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
}

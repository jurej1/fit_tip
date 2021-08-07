part of 'running_workout_day_bloc.dart';

class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState({
    required this.workoutDay,
  });

  final WorkoutDay workoutDay;

  @override
  List<Object> get props => [workoutDay];

  RunningWorkoutDayState copyWith({
    WorkoutDay? workoutDay,
  }) {
    return RunningWorkoutDayState(
      workoutDay: workoutDay ?? this.workoutDay,
    );
  }
}

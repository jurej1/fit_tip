part of 'workout_active_bloc.dart';

class WorkoutActiveState extends Equatable {
  const WorkoutActiveState({
    required this.workoutDay,
  });

  final WorkoutDay workoutDay;

  @override
  List<Object> get props => [workoutDay];

  WorkoutActiveState copyWith({
    WorkoutDay? workoutDay,
  }) {
    return WorkoutActiveState(
      workoutDay: workoutDay ?? this.workoutDay,
    );
  }
}

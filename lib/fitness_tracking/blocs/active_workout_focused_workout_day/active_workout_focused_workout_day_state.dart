part of 'active_workout_focused_workout_day_bloc.dart';

abstract class ActiveWorkoutFocusedWorkoutDayState extends Equatable {
  const ActiveWorkoutFocusedWorkoutDayState();

  @override
  List<Object?> get props => [];
}

class ActiveWorkoutFocusedWorkoutDayLoading extends ActiveWorkoutFocusedWorkoutDayState {}

class ActiveWorkoutFocusedWorkoutDayLoadSuccess extends ActiveWorkoutFocusedWorkoutDayState {
  final WorkoutDay? workout;

  const ActiveWorkoutFocusedWorkoutDayLoadSuccess([this.workout]);

  @override
  List<Object?> get props => [workout];
}

class ActiveWorkoutFocusedWorkoutDayFail extends ActiveWorkoutFocusedWorkoutDayState {}

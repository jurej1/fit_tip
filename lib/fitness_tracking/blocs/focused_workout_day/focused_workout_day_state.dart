part of 'focused_workout_day_bloc.dart';

abstract class FocusedWorkoutDayState extends Equatable {
  const FocusedWorkoutDayState();

  @override
  List<Object?> get props => [];
}

class FocusedWorkoutDayLoading extends FocusedWorkoutDayState {}

class FocusedWorkoutDayLoadSuccess extends FocusedWorkoutDayState {
  final WorkoutDay? workoutDay;

  const FocusedWorkoutDayLoadSuccess([this.workoutDay]);
  @override
  List<Object?> get props => [workoutDay];
}

class FocusedWorkoutDayFail extends FocusedWorkoutDayState {}

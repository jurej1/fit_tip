part of 'focused_workout_day_bloc.dart';

abstract class FocusedWorkoutDayState extends Equatable {
  const FocusedWorkoutDayState();

  @override
  List<Object?> get props => [];
}

class FocusedWorkoutDayLoading extends FocusedWorkoutDayState {}

class FocusedWorkoutDayLoadSuccess extends FocusedWorkoutDayState {
  final WorkoutDay? workoutDay;
  final DateTime date;

  const FocusedWorkoutDayLoadSuccess(this.date, [this.workoutDay]);
  @override
  List<Object?> get props => [workoutDay, date];
}

class FocusedWorkoutDayFail extends FocusedWorkoutDayState {}

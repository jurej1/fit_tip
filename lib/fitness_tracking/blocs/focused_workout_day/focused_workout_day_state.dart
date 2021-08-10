part of 'focused_workout_day_bloc.dart';

abstract class FocusedWorkoutDayState extends Equatable {
  const FocusedWorkoutDayState();

  @override
  List<Object?> get props => [];
}

class FocusedWorkoutDayLoading extends FocusedWorkoutDayState {}

class FocusedWorkoutDayLoadSuccess extends FocusedWorkoutDayState {
  final WorkoutDay? workoutDay;
  final List<WorkoutDayLog> workoutDayLog;
  final DateTime date;

  const FocusedWorkoutDayLoadSuccess({required this.date, this.workoutDay, this.workoutDayLog = const []});
  @override
  List<Object?> get props => [workoutDay, date, workoutDayLog];
}

class FocusedWorkoutDayFail extends FocusedWorkoutDayState {}

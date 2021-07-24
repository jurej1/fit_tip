part of 'focused_workout_day_bloc.dart';

abstract class FocusedWorkoutDayEvent extends Equatable {
  const FocusedWorkoutDayEvent();

  @override
  List<Object> get props => [];
}

class _FocusedWorkoutDayFailRequested extends FocusedWorkoutDayEvent {}

class FocusedWorkoutDayDateUpdated extends FocusedWorkoutDayEvent {
  final DateTime value;

  const FocusedWorkoutDayDateUpdated(this.value);
  @override
  List<Object> get props => [value];
}

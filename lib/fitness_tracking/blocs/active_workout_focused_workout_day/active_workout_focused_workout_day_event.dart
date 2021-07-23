part of 'active_workout_focused_workout_day_bloc.dart';

abstract class ActiveWorkoutFocusedWorkoutDayEvent extends Equatable {
  const ActiveWorkoutFocusedWorkoutDayEvent();

  @override
  List<Object> get props => [];
}

class ActiveWorkoutFocusedWorkoutDayDayUpdated extends ActiveWorkoutFocusedWorkoutDayEvent {
  final DateTime date;

  const ActiveWorkoutFocusedWorkoutDayDayUpdated(this.date);
  @override
  List<Object> get props => [date];
}

class _ActiveWorkoutFocusedWorkoutDayFailRequested extends ActiveWorkoutFocusedWorkoutDayEvent {}

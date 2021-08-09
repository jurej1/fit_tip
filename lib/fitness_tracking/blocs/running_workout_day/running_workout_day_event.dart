part of 'running_workout_day_bloc.dart';

abstract class RunningWorkoutDayEvent extends Equatable {
  const RunningWorkoutDayEvent();

  @override
  List<Object> get props => [];
}

class RunningWorkoutDayPageIndexUpdated extends RunningWorkoutDayEvent {
  final int value;

  const RunningWorkoutDayPageIndexUpdated(this.value);

  @override
  List<Object> get props => [value];
}

class RunningWorkoutDayWorkoutExcerciseUpdated extends RunningWorkoutDayEvent {
  final WorkoutExcercise excercise;

  const RunningWorkoutDayWorkoutExcerciseUpdated(this.excercise);

  @override
  List<Object> get props => [excercise];
}

class RunningWorkoutDayWorkoutExcerciseSubmit extends RunningWorkoutDayEvent {}

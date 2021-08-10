part of 'workout_day_logs_bloc.dart';

abstract class WorkoutDayLogsEvent extends Equatable {
  const WorkoutDayLogsEvent();

  @override
  List<Object> get props => [];
}

class _WorkoutDayLogsWorkoutUpdated extends WorkoutDayLogsEvent {
  final Workout workout;

  const _WorkoutDayLogsWorkoutUpdated(this.workout);
  @override
  List<Object> get props => [workout];
}

class WorkoutDayLogsLogAdded extends WorkoutDayLogsEvent {
  final WorkoutDayLog log;

  const WorkoutDayLogsLogAdded(this.log);
  @override
  List<Object> get props => [log];
}

class WorkoutDayLogsLogRemoved extends WorkoutDayLogsEvent {
  final WorkoutDayLog log;

  const WorkoutDayLogsLogRemoved(this.log);
  @override
  List<Object> get props => [log];
}

class WorkoutDayLogsLogUpdated extends WorkoutDayLogsEvent {
  final WorkoutDayLog log;

  const WorkoutDayLogsLogUpdated(this.log);
  @override
  List<Object> get props => [log];
}

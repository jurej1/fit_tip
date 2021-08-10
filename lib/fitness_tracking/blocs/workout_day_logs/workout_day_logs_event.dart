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

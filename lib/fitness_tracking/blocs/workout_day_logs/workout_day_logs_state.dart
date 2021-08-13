part of 'workout_day_logs_bloc.dart';

abstract class WorkoutDayLogsState {
  const WorkoutDayLogsState();
}

class WorkoutDayLogsLoading extends WorkoutDayLogsState {}

class WorkoutDayLogsLoadSuccess extends WorkoutDayLogsState {
  final List<WorkoutDayLog> logs;

  const WorkoutDayLogsLoadSuccess([this.logs = const []]);
}

class WorkoutDayLogsFailure extends WorkoutDayLogsState {}

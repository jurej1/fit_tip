part of 'excercise_daily_progress_bloc.dart';

abstract class ExcerciseDailyProgressEvent extends Equatable {
  const ExcerciseDailyProgressEvent();

  @override
  List<Object> get props => [];
}

class _ExcerciseDailyProgressExcercisesUpdated extends ExcerciseDailyProgressEvent {
  final List<ExcerciseLog> excercises;

  const _ExcerciseDailyProgressExcercisesUpdated([this.excercises = const []]);

  @override
  List<Object> get props => [excercises];
}

class _ExcerciseDailyProgressGoalUpdated extends ExcerciseDailyProgressEvent {
  final ExcerciseDailyGoal goal;

  const _ExcerciseDailyProgressGoalUpdated(this.goal);

  @override
  List<Object> get props => [goal];
}

class ExcerciseDailyProgressViewUpdated extends ExcerciseDailyProgressEvent {
  final int index;

  const ExcerciseDailyProgressViewUpdated(this.index);
  @override
  List<Object> get props => [index];
}

class _ExcerciseDailyProgressGoalFailRequested extends ExcerciseDailyProgressEvent {}

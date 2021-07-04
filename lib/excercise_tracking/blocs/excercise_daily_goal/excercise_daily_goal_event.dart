part of 'excercise_daily_goal_bloc.dart';

abstract class ExcerciseDailyGoalEvent extends Equatable {
  const ExcerciseDailyGoalEvent();

  @override
  List<Object> get props => [];
}

class ExcerciseDailyGoalDateUpdated extends ExcerciseDailyGoalEvent {
  final DateTime date;

  const ExcerciseDailyGoalDateUpdated(this.date);

  @override
  List<Object> get props => [date];
}

class ExcerciseDailyGoalUpdated extends ExcerciseDailyGoalEvent {
  final ExcerciseDailyGoal goal;

  const ExcerciseDailyGoalUpdated(this.goal);
  @override
  List<Object> get props => [goal];
}

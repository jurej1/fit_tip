part of 'calorie_daily_goal_bloc.dart';

abstract class CalorieDailyGoalEvent extends Equatable {
  const CalorieDailyGoalEvent();

  @override
  List<Object?> get props => [];
}

class CalorieDailyGoalFocusedDateUpdated extends CalorieDailyGoalEvent {
  final DateTime? date;

  const CalorieDailyGoalFocusedDateUpdated({this.date});

  @override
  List<Object?> get props => [date];
}

class CalorieDailyGoalUpdated extends CalorieDailyGoalEvent {
  final CalorieDailyGoal? calorieDailyGoal;

  const CalorieDailyGoalUpdated({
    this.calorieDailyGoal,
  });

  @override
  List<Object?> get props => [calorieDailyGoal];
}

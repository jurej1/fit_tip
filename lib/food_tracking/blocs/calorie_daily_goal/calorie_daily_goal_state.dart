part of 'calorie_daily_goal_bloc.dart';

abstract class CalorieDailyGoalState extends Equatable {
  const CalorieDailyGoalState();

  @override
  List<Object?> get props => [];
}

class CalorieDailyGoalLoading extends CalorieDailyGoalState {}

class CalorieDailyGoalLoadSuccess extends CalorieDailyGoalState {
  final CalorieDailyGoal? calorieDailyGoal;

  const CalorieDailyGoalLoadSuccess({
    this.calorieDailyGoal,
  });

  @override
  List<Object?> get props => [calorieDailyGoal];
}

class CalorieDailyGoalFailure extends CalorieDailyGoalState {
  final String? errorMsg;

  const CalorieDailyGoalFailure({
    this.errorMsg,
  });

  @override
  List<Object?> get props => [errorMsg];
}

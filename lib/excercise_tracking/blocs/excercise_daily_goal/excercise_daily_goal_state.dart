part of 'excercise_daily_goal_bloc.dart';

abstract class ExcerciseDailyGoalState extends Equatable {
  const ExcerciseDailyGoalState();

  @override
  List<Object> get props => [];
}

class ExcerciseDailyGoalLoading extends ExcerciseDailyGoalState {}

class ExcerciseDailyGoalLoadSuccess extends ExcerciseDailyGoalState {
  final ExcerciseDailyGoal goal;

  const ExcerciseDailyGoalLoadSuccess(this.goal);
  @override
  List<Object> get props => [goal];
}

class ExcerciseDailyGoalFailure extends ExcerciseDailyGoalState {
  final String errorMsg;

  const ExcerciseDailyGoalFailure(this.errorMsg);
  @override
  List<Object> get props => [errorMsg];
}

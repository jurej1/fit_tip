part of 'water_daily_goal_bloc.dart';

abstract class WaterDailyGoalState extends Equatable {
  const WaterDailyGoalState();

  @override
  List<Object> get props => [];
}

class WaterDailyGoalLoading extends WaterDailyGoalState {}

class WaterDailyGoalSuccess extends WaterDailyGoalState {
  final WaterDailyGoal goal;

  const WaterDailyGoalSuccess(this.goal);

  @override
  List<Object> get props => [goal];
}

class WaterDailyGoalFailure extends WaterDailyGoalState {
  final String errorMsg;

  const WaterDailyGoalFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

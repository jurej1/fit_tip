part of 'water_daily_goal_bloc.dart';

abstract class WaterDailyGoalEvent extends Equatable {
  const WaterDailyGoalEvent();

  @override
  List<Object> get props => [];
}

class WaterDailyGoalDateUpdated extends WaterDailyGoalEvent {
  final DateTime date;

  const WaterDailyGoalDateUpdated(this.date);

  @override
  List<Object> get props => [date];
}

class WaterDailyGoalAmountUpdated extends WaterDailyGoalEvent {
  final double amount;

  const WaterDailyGoalAmountUpdated(this.amount);

  @override
  List<Object> get props => [amount];
}

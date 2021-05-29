part of 'water_log_consumption_bloc.dart';

abstract class WaterLogConsumptionEvent extends Equatable {
  const WaterLogConsumptionEvent();

  @override
  List<Object> get props => [];
}

class WaterLogConsumptionDayAmountUpdated extends WaterLogConsumptionEvent {
  final double amount;

  const WaterLogConsumptionDayAmountUpdated(this.amount);

  @override
  List<Object> get props => [amount];
}

class WaterLogConsumptionGoalAmountUpdated extends WaterLogConsumptionEvent {
  final double amount;

  const WaterLogConsumptionGoalAmountUpdated(this.amount);

  @override
  List<Object> get props => [amount];
}

class WaterLogConsumptionRequestError extends WaterLogConsumptionEvent {}

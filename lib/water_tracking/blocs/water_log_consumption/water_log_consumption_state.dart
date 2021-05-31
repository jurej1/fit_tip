part of 'water_log_consumption_bloc.dart';

abstract class WaterLogConsumptionState {
  const WaterLogConsumptionState();
}

class WaterLogConsumptionLoading extends WaterLogConsumptionState {}

class WaterLogConsumptionLoadSucccess extends WaterLogConsumptionState {
  final double amount;
  final double max;

  const WaterLogConsumptionLoadSucccess({
    required this.amount,
    required this.max,
  });
}

class WaterLogConsumptionFailure extends WaterLogConsumptionState {}

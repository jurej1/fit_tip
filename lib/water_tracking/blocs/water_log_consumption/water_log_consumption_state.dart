part of 'water_log_consumption_bloc.dart';

abstract class WaterLogConsumptionState extends Equatable {
  const WaterLogConsumptionState();

  @override
  List<Object?> get props => [];
}

class WaterLogConsumptionLoading extends WaterLogConsumptionState {}

class WaterLogConsumptionLoadSucccess extends WaterLogConsumptionState {
  final double amount;
  final double max;

  const WaterLogConsumptionLoadSucccess({
    required this.amount,
    required this.max,
  });

  @override
  List<Object?> get props => [this.amount, this.max];
}

class WaterLogConsumptionFailure extends WaterLogConsumptionState {}

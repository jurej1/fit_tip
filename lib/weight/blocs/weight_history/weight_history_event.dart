part of 'weight_history_bloc.dart';

abstract class WeightHistoryEvent extends Equatable {
  const WeightHistoryEvent();

  @override
  List<Object?> get props => [];
}

class WeightHistoryLoad extends WeightHistoryEvent {}

class WeightHistoryAdded extends WeightHistoryEvent {
  final Weight? weight;

  const WeightHistoryAdded(this.weight);
  @override
  List<Object?> get props => [weight];
}

class WeightHistoryDelete extends WeightHistoryEvent {
  final Weight? weight;

  const WeightHistoryDelete(this.weight);
  @override
  List<Object?> get props => [weight];
}

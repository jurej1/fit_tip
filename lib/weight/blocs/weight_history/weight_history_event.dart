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

class WeightHistoryDeleted extends WeightHistoryEvent {
  final Weight? weight;

  const WeightHistoryDeleted(this.weight);
  @override
  List<Object?> get props => [weight];
}

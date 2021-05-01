part of 'weight_history_bloc.dart';

abstract class WeightHistoryEvent extends Equatable {
  const WeightHistoryEvent();

  @override
  List<Object> get props => [];
}

class WeightHistoryLoad extends WeightHistoryState {}

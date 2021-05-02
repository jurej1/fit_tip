part of 'weight_history_bloc.dart';

abstract class WeightHistoryState extends Equatable {
  const WeightHistoryState();

  @override
  List<Object> get props => [];
}

class WeightHistoryLoading extends WeightHistoryState {}

abstract class _WeightHistoryLoadSucces extends WeightHistoryState {
  final List<Weight> weights;

  const _WeightHistoryLoadSucces({required this.weights});

  @override
  List<Object> get props => [weights];
}

class WeightHistorySuccesfullyLoaded extends _WeightHistoryLoadSucces {
  WeightHistorySuccesfullyLoaded({required List<Weight> weights}) : super(weights: weights);
}

class WeightHistoryWeightDeleted extends _WeightHistoryLoadSucces {
  const WeightHistoryWeightDeleted({required List<Weight> weights}) : super(weights: weights);
}

class WeightHistoryFailure extends WeightHistoryState {}

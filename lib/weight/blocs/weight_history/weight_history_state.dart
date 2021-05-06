part of 'weight_history_bloc.dart';

abstract class WeightHistoryState {
  const WeightHistoryState();
}

class WeightHistoryLoading extends WeightHistoryState {}

class WeightHistoryLoadSucces extends WeightHistoryState {
  final List<Weight> weights;

  const WeightHistoryLoadSucces({required this.weights});
}

class WeightHistoryFailure extends WeightHistoryState {}

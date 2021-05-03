part of 'weight_history_bloc.dart';

abstract class WeightHistoryState extends Equatable {
  const WeightHistoryState();

  @override
  List<Object> get props => [];
}

class WeightHistoryLoading extends WeightHistoryState {}

class WeightHistoryLoadSucces extends WeightHistoryState {
  final List<Weight> weights;

  const WeightHistoryLoadSucces({required this.weights});

  @override
  List<Object> get props => [weights];
}

class WeightHistoryFailure extends WeightHistoryState {}

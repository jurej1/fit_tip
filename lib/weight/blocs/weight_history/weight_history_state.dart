part of 'weight_history_bloc.dart';

abstract class WeightHistoryState extends Equatable {
  const WeightHistoryState();

  @override
  List<Object> get props => [];
}

class WeightHistoryLoading extends WeightHistoryState {}

class WeightHistorySuccesfullyLoaded extends WeightHistoryState {
  final List<Weight> weights;

  const WeightHistorySuccesfullyLoaded({this.weights = const []});

  @override
  List<Object> get props => [weights];
}

class WeightHistoryFailure extends WeightHistoryState {}

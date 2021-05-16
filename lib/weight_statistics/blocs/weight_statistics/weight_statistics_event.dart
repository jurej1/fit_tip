part of 'weight_statistics_bloc.dart';

abstract class WeightStatisticsEvent extends Equatable {
  const WeightStatisticsEvent();

  @override
  List<Object> get props => [];
}

class _WeightHistoryUpdated extends WeightStatisticsEvent {
  final List<Weight> weights;

  const _WeightHistoryUpdated({this.weights = const []});

  @override
  List<Object> get props => [weights];
}

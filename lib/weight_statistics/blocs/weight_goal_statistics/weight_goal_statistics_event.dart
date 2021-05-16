part of 'weight_goal_statistics_bloc.dart';

abstract class WeightGoalStatisticsEvent extends Equatable {
  const WeightGoalStatisticsEvent();

  @override
  List<Object> get props => [];
}

class _WeightGoalUpdated extends WeightGoalStatisticsEvent {
  final WeightGoal goal;

  const _WeightGoalUpdated(this.goal);

  @override
  List<Object> get props => [goal];
}

class _WeightGoalFailure extends WeightGoalStatisticsEvent {}

class _WeightHistoryFailure extends WeightGoalStatisticsEvent {}

class _WeightHistoryUpdated extends WeightGoalStatisticsEvent {
  final List<Weight> weights;

  _WeightHistoryUpdated(this.weights);
}

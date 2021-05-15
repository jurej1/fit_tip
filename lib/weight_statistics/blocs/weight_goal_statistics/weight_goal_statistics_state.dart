part of 'weight_goal_statistics_bloc.dart';

abstract class WeightGoalStatisticsState extends Equatable {
  const WeightGoalStatisticsState();

  @override
  List<Object> get props => [];
}

class WeightGoalStatisticsLoading extends WeightGoalStatisticsState {}

class WeightGoalStatisticsFailure extends WeightGoalStatisticsState {}

class WeightGoalStatisticsLoadSuccess extends WeightGoalStatisticsState {
  final double percentageDone;
  final double remaining;

  const WeightGoalStatisticsLoadSuccess({
    this.percentageDone = 0,
    this.remaining = 0,
  });

  @override
  List<Object> get props => [percentageDone, remaining];
}

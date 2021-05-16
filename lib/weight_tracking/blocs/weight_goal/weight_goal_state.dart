part of 'weight_goal_bloc.dart';

abstract class WeightGoalState extends Equatable {
  const WeightGoalState();

  @override
  List<Object> get props => [];
}

class WeightGoalLoading extends WeightGoalState {}

class WeightGoalLoadSuccess extends WeightGoalState {
  final WeightGoal goal;

  const WeightGoalLoadSuccess({required this.goal});

  @override
  List<Object> get props => [goal];
}

class WeightGoalFailure extends WeightGoalState {}

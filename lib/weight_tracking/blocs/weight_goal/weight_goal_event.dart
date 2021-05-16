part of 'weight_goal_bloc.dart';

abstract class WeightGoalEvent extends Equatable {
  const WeightGoalEvent();

  @override
  List<Object?> get props => [];
}

class WeightGoalLoadEvent extends WeightGoalEvent {}

class WeightGoalUpdated extends WeightGoalEvent {
  final WeightGoal? weightGoal;

  const WeightGoalUpdated(this.weightGoal);

  @override
  List<Object?> get props => [weightGoal];
}

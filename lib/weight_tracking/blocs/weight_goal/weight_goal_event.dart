part of 'weight_goal_bloc.dart';

abstract class WeightGoalEvent extends Equatable {
  const WeightGoalEvent();

  @override
  List<Object> get props => [];
}

class WeightGoalLoadEvent extends WeightGoalEvent {}

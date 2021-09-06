part of 'workout_infos_base_bloc.dart';

abstract class WorkoutInfosBaseState extends Equatable {
  const WorkoutInfosBaseState();

  @override
  List<Object> get props => [];
}

class WorkoutInfosLoading extends WorkoutInfosBaseState {}

class WorkoutInfosLoadSuccess extends WorkoutInfosBaseState {
  final List<WorkoutInfo> infos;
  final bool hasReachedMax;

  const WorkoutInfosLoadSuccess(this.infos, this.hasReachedMax);

  @override
  List<Object> get props => [infos, hasReachedMax];
}

class WorkoutInfosFail extends WorkoutInfosBaseState {}

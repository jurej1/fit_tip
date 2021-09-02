part of 'workouts_list_bloc.dart';

abstract class WorkoutsListState {
  const WorkoutsListState();
}

class WorkoutsListLoading extends WorkoutsListState {}

class WorkoutsListLoadSuccess extends WorkoutsListState {
  final List<WorkoutInfo> workoutInfos;
  final bool hasReachedMax;

  const WorkoutsListLoadSuccess(
    this.workoutInfos,
    this.hasReachedMax,
  );
}

class WorkoutsListFail extends WorkoutsListState {}

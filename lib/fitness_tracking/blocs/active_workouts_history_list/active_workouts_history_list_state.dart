part of 'active_workouts_history_list_bloc.dart';

abstract class ActiveWorkoutsHistoryListState {
  const ActiveWorkoutsHistoryListState();
}

class ActiveWorkoutsHistoryListLoading extends ActiveWorkoutsHistoryListState {}

class ActiveWorkoutsHistoryListLoadSuccess extends ActiveWorkoutsHistoryListState {
  final List<ActiveWorkout> workouts;
  final bool hasReachedMax;

  const ActiveWorkoutsHistoryListLoadSuccess({
    this.workouts = const [],
    this.hasReachedMax = false,
  });
}

class ActiveWorkoutsHistoryListFail extends ActiveWorkoutsHistoryListState {}

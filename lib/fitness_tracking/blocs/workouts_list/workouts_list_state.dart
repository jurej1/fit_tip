part of 'workouts_list_bloc.dart';

abstract class WorkoutsListState {
  const WorkoutsListState();
}

class WorkoutsListLoading extends WorkoutsListState {}

class WorkoutsListLoadSuccess extends WorkoutsListState {
  final List<Workout> workouts;

  const WorkoutsListLoadSuccess(this.workouts);
}

class WorkoutsListFail extends WorkoutsListState {}

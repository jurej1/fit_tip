part of 'workouts_list_bloc.dart';

abstract class WorkoutsListState {
  const WorkoutsListState();
}

class WorkoutsListInitial extends WorkoutsListState {}

class WorkoutsListLoadSuccess extends WorkoutsListState {
  final List<Workout> workouts;

  const WorkoutsListLoadSuccess(this.workouts);
}

class WorkoutListFail extends WorkoutsListState {}

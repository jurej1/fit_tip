part of 'workouts_list_bloc.dart';

abstract class WorkoutsListEvent extends Equatable {
  const WorkoutsListEvent();

  @override
  List<Object> get props => [];
}

class WorkoutListLoadRequested extends WorkoutsListEvent {}

class WorkoutListItemAdded extends WorkoutsListEvent {
  final Workout workout;

  const WorkoutListItemAdded(this.workout);
}

class WorkoutListItemRemoved extends WorkoutsListEvent {
  final Workout workout;

  const WorkoutListItemRemoved(this.workout);
}

class WorkoutListItemUpdated extends WorkoutsListEvent {
  final Workout workout;

  const WorkoutListItemUpdated(this.workout);
}

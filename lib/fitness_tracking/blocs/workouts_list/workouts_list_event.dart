part of 'workouts_list_bloc.dart';

abstract class WorkoutsListEvent extends Equatable {
  const WorkoutsListEvent();

  @override
  List<Object> get props => [];
}

class WorkoutsListLoadRequested extends WorkoutsListEvent {}

class WorkoutsListItemAdded extends WorkoutsListEvent {
  final Workout workout;

  const WorkoutsListItemAdded(this.workout);
}

class WorkoutsListItemRemoved extends WorkoutsListEvent {
  final Workout workout;

  const WorkoutsListItemRemoved(this.workout);
}

class WorkoutsListItemUpdated extends WorkoutsListEvent {
  final Workout workout;

  const WorkoutsListItemUpdated(this.workout);
}

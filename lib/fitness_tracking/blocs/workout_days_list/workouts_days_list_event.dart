part of 'workouts_days_list_bloc.dart';

abstract class WorkoutsDaysListEvent extends Equatable {
  const WorkoutsDaysListEvent();

  @override
  List<Object> get props => [];
}

class WorkoutDaysListItemAdded extends WorkoutsDaysListEvent {
  final WorkoutDay workoutDay;

  const WorkoutDaysListItemAdded(this.workoutDay);

  @override
  List<Object> get props => [workoutDay];
}

class WorkoutDaysListItemRemoved extends WorkoutsDaysListEvent {
  final WorkoutDay workoutDay;

  const WorkoutDaysListItemRemoved(this.workoutDay);

  @override
  List<Object> get props => [workoutDay];
}

class WorkoutDaysListItemUpdated extends WorkoutsDaysListEvent {
  final WorkoutDay workoutDay;

  const WorkoutDaysListItemUpdated(this.workoutDay);

  @override
  List<Object> get props => [workoutDay];
}

class WorkoutDaysListWorkoutsPerWeekUpdated extends WorkoutsDaysListEvent {
  final int workouts;

  const WorkoutDaysListWorkoutsPerWeekUpdated(this.workouts);

  @override
  List<Object> get props => [workouts];
}

class WorkoutsDaysListFormSubmited extends WorkoutsDaysListEvent {}

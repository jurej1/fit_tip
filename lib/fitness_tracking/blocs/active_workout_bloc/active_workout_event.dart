part of 'active_workout_bloc.dart';

abstract class ActiveWorkoutEvent extends Equatable {
  const ActiveWorkoutEvent();

  @override
  List<Object> get props => [];
}

class _ActiveWorkoutFailureRquested extends ActiveWorkoutEvent {}

class _ActiveWorkoutListUpdated extends ActiveWorkoutEvent {
  final List<Workout> workouts;

  const _ActiveWorkoutListUpdated({this.workouts = const []});
  @override
  List<Object> get props => [workouts];
}

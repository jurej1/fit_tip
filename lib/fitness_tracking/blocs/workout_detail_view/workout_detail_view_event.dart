part of 'workout_detail_view_bloc.dart';

abstract class WorkoutDetailViewEvent extends Equatable {
  const WorkoutDetailViewEvent();

  @override
  List<Object> get props => [];
}

class WorkoutDetailViewWorkoutUpdated extends WorkoutDetailViewEvent {
  final Workout workout;

  const WorkoutDetailViewWorkoutUpdated(this.workout);
  @override
  List<Object> get props => [workout];
}

class WorkoutDetailViewDaysLoadRequested extends WorkoutDetailViewEvent {}

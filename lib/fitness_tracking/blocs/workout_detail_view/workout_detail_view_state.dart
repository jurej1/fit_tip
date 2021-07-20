part of 'workout_detail_view_bloc.dart';

abstract class WorkoutDetailViewState extends Equatable {
  const WorkoutDetailViewState(
    this.workout,
  );

  final Workout workout;

  @override
  List<Object> get props => [workout];
}

class WorkoutDetailViewInitial extends WorkoutDetailViewState {
  const WorkoutDetailViewInitial(Workout workout) : super(workout);
}

class WorkoutDetailViewLoading extends WorkoutDetailViewState {
  const WorkoutDetailViewLoading(Workout workout) : super(workout);
}

class WorkoutDetailViewDeleteSuccess extends WorkoutDetailViewState {
  const WorkoutDetailViewDeleteSuccess(Workout workout) : super(workout);
}

class WorkoutDetailViewFail extends WorkoutDetailViewState {
  const WorkoutDetailViewFail(Workout workout) : super(workout);
}

class WorkoutDetailViewSetAsActiveSuccess extends WorkoutDetailViewState {
  const WorkoutDetailViewSetAsActiveSuccess(Workout workout) : super(workout);
}

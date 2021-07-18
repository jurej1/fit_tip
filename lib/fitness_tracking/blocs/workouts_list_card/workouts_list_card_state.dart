part of 'workouts_list_card_bloc.dart';

abstract class WorkoutsListCardState extends Equatable {
  const WorkoutsListCardState(this.workout);

  final Workout workout;

  @override
  List<Object> get props => [workout];
}

class WorkoutsListCardInitial extends WorkoutsListCardState {
  const WorkoutsListCardInitial(Workout workout) : super(workout);
}

class WorkoutsListCardLoading extends WorkoutsListCardState {
  const WorkoutsListCardLoading(Workout workout) : super(workout);
}

class WorkoutsListCardDeleteSuccess extends WorkoutsListCardState {
  const WorkoutsListCardDeleteSuccess(Workout workout) : super(workout);
}

class WorkoutsListCardFail extends WorkoutsListCardState {
  const WorkoutsListCardFail(Workout workout) : super(workout);
}

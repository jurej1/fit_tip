part of 'workouts_list_card_bloc.dart';

abstract class WorkoutsListCardState extends Equatable {
  const WorkoutsListCardState(this.workout, this.isExpanded);

  final Workout workout;
  final bool isExpanded;

  Color get backgroundColor => Colors.blue.shade100;
  BorderRadius get borderRadius => BorderRadius.circular(12);

  @override
  List<Object> get props => [workout, isExpanded];
}

class WorkoutsListCardInitial extends WorkoutsListCardState {
  WorkoutsListCardInitial(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardLoading extends WorkoutsListCardState {
  WorkoutsListCardLoading(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardDeleteSuccess extends WorkoutsListCardState {
  WorkoutsListCardDeleteSuccess(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardFail extends WorkoutsListCardState {
  WorkoutsListCardFail(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

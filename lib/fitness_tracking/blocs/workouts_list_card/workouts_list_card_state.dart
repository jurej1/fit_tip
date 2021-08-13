part of 'workouts_list_card_bloc.dart';

abstract class WorkoutsListCardState extends Equatable {
  const WorkoutsListCardState(this.workout, this.isExpanded);

  final Workout workout;
  final bool isExpanded;

  Color get backgroundColor {
    if (workout.isActive) return Colors.lightBlueAccent.shade100;
    return Colors.blue.shade100;
  }

  BorderRadius get borderRadius => BorderRadius.circular(12);
  double get iconSize => 20;

  @override
  List<Object> get props => [workout, isExpanded];
}

class WorkoutsListCardInitial extends WorkoutsListCardState {
  const WorkoutsListCardInitial(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardLoading extends WorkoutsListCardState {
  const WorkoutsListCardLoading(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardDeleteSuccess extends WorkoutsListCardState {
  const WorkoutsListCardDeleteSuccess(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardFail extends WorkoutsListCardState {
  const WorkoutsListCardFail(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

class WorkoutsListCardSetAsActiveSuccess extends WorkoutsListCardState {
  const WorkoutsListCardSetAsActiveSuccess(Workout workout, bool isExpanded) : super(workout, isExpanded);
}

part of 'workouts_list_card_bloc.dart';

abstract class WorkoutsListCardState extends Equatable {
  const WorkoutsListCardState(this.info, this.isExpanded);

  final WorkoutInfo info;
  final bool isExpanded;

  Color get backgroundColor {
    // if (workout.isActive) return Colors.lightBlueAccent.shade100;
    return Colors.blue.shade100;
  }

  BorderRadius get borderRadius => BorderRadius.circular(12);
  double get iconSize => 20;

  @override
  List<Object> get props => [info, isExpanded];
}

class WorkoutsListCardInitial extends WorkoutsListCardState {
  const WorkoutsListCardInitial(WorkoutInfo info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardLoading extends WorkoutsListCardState {
  const WorkoutsListCardLoading(WorkoutInfo info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardDeleteSuccess extends WorkoutsListCardState {
  const WorkoutsListCardDeleteSuccess(WorkoutInfo info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardFail extends WorkoutsListCardState {
  const WorkoutsListCardFail(WorkoutInfo info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardSetAsActiveSuccess extends WorkoutsListCardState {
  const WorkoutsListCardSetAsActiveSuccess(WorkoutInfo info, bool isExpanded) : super(info, isExpanded);
}

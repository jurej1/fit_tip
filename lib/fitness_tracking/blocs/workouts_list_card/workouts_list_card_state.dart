part of 'workouts_list_card_bloc.dart';

abstract class WorkoutsListCardState extends Equatable {
  const WorkoutsListCardState(this.info, this.isExpanded);

  final WorkoutInfoX info;
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
  const WorkoutsListCardInitial(WorkoutInfoX info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardLoading extends WorkoutsListCardState {
  const WorkoutsListCardLoading(WorkoutInfoX info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardDeleteSuccess extends WorkoutsListCardState {
  const WorkoutsListCardDeleteSuccess(WorkoutInfoX info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardFail extends WorkoutsListCardState {
  const WorkoutsListCardFail(WorkoutInfoX info, bool isExpanded) : super(info, isExpanded);
}

class WorkoutsListCardSetAsActiveSuccess extends WorkoutsListCardState {
  const WorkoutsListCardSetAsActiveSuccess(WorkoutInfoX info, bool isExpanded) : super(info, isExpanded);
}

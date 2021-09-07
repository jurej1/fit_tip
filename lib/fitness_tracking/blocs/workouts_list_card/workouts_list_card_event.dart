part of 'workouts_list_card_bloc.dart';

abstract class WorkoutsListCardEvent extends Equatable {
  const WorkoutsListCardEvent();

  @override
  List<Object> get props => [];
}

class WorkoutsListCardExpandedButtonPressed extends WorkoutsListCardEvent {}

class WorkoutsListCardSetAsActiveRequested extends WorkoutsListCardEvent {}

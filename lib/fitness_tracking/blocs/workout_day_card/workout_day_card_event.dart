part of 'workout_day_card_bloc.dart';

abstract class WorkoutDayCardEvent extends Equatable {
  const WorkoutDayCardEvent();

  @override
  List<Object> get props => [];
}

class WorkoutDayCardExpandedButtonPressed extends WorkoutDayCardEvent {}

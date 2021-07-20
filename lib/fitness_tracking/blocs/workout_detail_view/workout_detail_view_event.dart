part of 'workout_detail_view_bloc.dart';

abstract class WorkoutDetailViewEvent extends Equatable {
  const WorkoutDetailViewEvent();

  @override
  List<Object> get props => [];
}

class WorkoutDetailViewDeleteRequested extends WorkoutDetailViewEvent {}

class WorkoutDetailViewSetAsActiveRequested extends WorkoutDetailViewEvent {}

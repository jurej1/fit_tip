part of 'workout_day_log_detail_bloc.dart';

abstract class WorkoutDayLogDetailEvent extends Equatable {
  const WorkoutDayLogDetailEvent();

  @override
  List<Object> get props => [];
}

class WorkoutDayLogDetailDeleteRequested extends WorkoutDayLogDetailEvent {}

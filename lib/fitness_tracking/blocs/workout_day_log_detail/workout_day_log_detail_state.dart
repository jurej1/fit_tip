part of 'workout_day_log_detail_bloc.dart';

abstract class WorkoutDayLogDetailState extends Equatable {
  const WorkoutDayLogDetailState(this.dayLog);

  final WorkoutDayLog dayLog;

  @override
  List<Object> get props => [dayLog];
}

class WorkoutDayLogDetailInitial extends WorkoutDayLogDetailState {
  const WorkoutDayLogDetailInitial(WorkoutDayLog dayLog) : super(dayLog);
}

class WorkoutDayLogDetailLoading extends WorkoutDayLogDetailState {
  const WorkoutDayLogDetailLoading(WorkoutDayLog dayLog) : super(dayLog);
}

class WorkoutDayLogDetailDeleteSuccess extends WorkoutDayLogDetailState {
  const WorkoutDayLogDetailDeleteSuccess(WorkoutDayLog dayLog) : super(dayLog);
}

class WorkoutDayLogDetailFail extends WorkoutDayLogDetailState {
  const WorkoutDayLogDetailFail(WorkoutDayLog dayLog) : super(dayLog);
}

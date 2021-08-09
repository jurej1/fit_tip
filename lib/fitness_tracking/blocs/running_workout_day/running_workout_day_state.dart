part of 'running_workout_day_bloc.dart';

abstract class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState(
    this.log,
    this.pageViewIndex,
  );

  final WorkoutDayLog log;
  final int pageViewIndex;

  int get pageViewLength => log.excercises.length + 1 + 1;

  @override
  List<Object> get props => [log, pageViewIndex];
}

class RunningWorkoutDayInitial extends RunningWorkoutDayState {
  const RunningWorkoutDayInitial(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

class RunningWorkoutLoading extends RunningWorkoutDayState {
  const RunningWorkoutLoading(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

class RunningWorkoutDayLoadSuccess extends RunningWorkoutDayState {
  const RunningWorkoutDayLoadSuccess(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

class RunningWorkoutDayFail extends RunningWorkoutDayState {
  const RunningWorkoutDayFail(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

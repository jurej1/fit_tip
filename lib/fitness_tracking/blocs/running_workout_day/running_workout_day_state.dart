part of 'running_workout_day_bloc.dart';

abstract class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState({
    required this.log,
    this.pageViewIndex = 0,
  });

  final WorkoutDayLog log;
  final int pageViewIndex;

  @override
  List<Object> get props => [log, pageViewIndex];

  int get pageViewLength => log.excercises.length + 1 + 1;
}

class RunningWorkoutDayInitial extends RunningWorkoutDayState {
  RunningWorkoutDayInitial({
    required WorkoutDayLog log,
    required int pageViewIndex,
  }) : super(
          log: log,
          pageViewIndex: pageViewIndex,
        );
}

class RunningWorkoutDayLoading extends RunningWorkoutDayState {
  RunningWorkoutDayLoading({
    required WorkoutDayLog log,
    required int pageViewIndex,
  }) : super(
          log: log,
          pageViewIndex: pageViewIndex,
        );
}

class RunningWorkoutDayLoadSuccess extends RunningWorkoutDayState {
  RunningWorkoutDayLoadSuccess({
    required WorkoutDayLog log,
    required int pageViewIndex,
  }) : super(
          log: log,
          pageViewIndex: pageViewIndex,
        );
}

class RunningWorkoutDayFailure extends RunningWorkoutDayState {
  RunningWorkoutDayFailure({
    required WorkoutDayLog log,
    required int pageViewIndex,
  }) : super(
          log: log,
          pageViewIndex: pageViewIndex,
        );
}

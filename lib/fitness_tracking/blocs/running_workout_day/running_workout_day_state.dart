part of 'running_workout_day_bloc.dart';

class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState({
    required this.log,
    this.pageViewIndex = 0,
  });

  final WorkoutDayLog log;
  final int pageViewIndex;

  int get pageViewLength => log.excercises.length + 1 + 1;

  RunningWorkoutDayState copyWith({
    WorkoutDayLog? log,
    int? pageViewIndex,
  }) {
    return RunningWorkoutDayState(
      log: log ?? this.log,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
    );
  }

  @override
  List<Object> get props => [log, pageViewIndex];
}

part of 'running_workout_day_bloc.dart';

class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState({
    required this.workoutDay,
    this.pageViewIndex = 0,
  });

  final WorkoutDay workoutDay;
  final int pageViewIndex;

  @override
  List<Object> get props => [workoutDay, pageViewIndex];

  RunningWorkoutDayState copyWith({
    WorkoutDay? workoutDay,
    int? pageViewIndex,
  }) {
    return RunningWorkoutDayState(
      workoutDay: workoutDay ?? this.workoutDay,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
    );
  }

  int get pageViewLength => workoutDay.excercises.length + 1 + 1;
}

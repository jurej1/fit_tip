part of 'running_workout_day_bloc.dart';

abstract class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState({
    required this.workoutDay,
    this.pageViewIndex = 0,
  });

  final WorkoutDay workoutDay;
  final int pageViewIndex;

  @override
  List<Object> get props => [workoutDay, pageViewIndex];

  int get pageViewLength => workoutDay.excercises.length + 1 + 1;
}

class RunningWorkoutDayInitial extends RunningWorkoutDayState {
  RunningWorkoutDayInitial({
    required WorkoutDay workoutDay,
    int pageViewIndex = 0,
  }) : super(workoutDay: workoutDay, pageViewIndex: pageViewIndex);
}

class RunningWorkoutDayLoading extends RunningWorkoutDayState {
  RunningWorkoutDayLoading({
    required WorkoutDay workoutDay,
    int pageViewIndex = 0,
  }) : super(workoutDay: workoutDay, pageViewIndex: pageViewIndex);
}

class RunningWorkoutDayLoadSuccess extends RunningWorkoutDayState {
  RunningWorkoutDayLoadSuccess({
    required WorkoutDay workoutDay,
    int pageViewIndex = 0,
  }) : super(workoutDay: workoutDay, pageViewIndex: pageViewIndex);
}

class RunningWorkoutDayFailure extends RunningWorkoutDayState {
  RunningWorkoutDayFailure({
    required WorkoutDay workoutDay,
    int pageViewIndex = 0,
  }) : super(workoutDay: workoutDay, pageViewIndex: pageViewIndex);
}

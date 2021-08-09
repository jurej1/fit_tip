part of 'running_workout_day_bloc.dart';

abstract class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState({
    required this.workoutDay,
    this.pageViewIndex = 0,
    required this.date,
  });

  final WorkoutDay workoutDay;
  final int pageViewIndex;
  final DateTime date;

  @override
  List<Object> get props => [workoutDay, pageViewIndex];

  int get pageViewLength => workoutDay.excercises.length + 1 + 1;
}

class RunningWorkoutDayInitial extends RunningWorkoutDayState {
  RunningWorkoutDayInitial({
    required WorkoutDay workoutDay,
    required int pageViewIndex,
    required DateTime date,
  }) : super(
          workoutDay: workoutDay,
          pageViewIndex: pageViewIndex,
          date: date,
        );
}

class RunningWorkoutDayLoading extends RunningWorkoutDayState {
  RunningWorkoutDayLoading({
    required WorkoutDay workoutDay,
    required int pageViewIndex,
    required DateTime date,
  }) : super(workoutDay: workoutDay, pageViewIndex: pageViewIndex, date: date);
}

class RunningWorkoutDayLoadSuccess extends RunningWorkoutDayState {
  RunningWorkoutDayLoadSuccess({
    required WorkoutDay workoutDay,
    required int pageViewIndex,
    required DateTime date,
  }) : super(workoutDay: workoutDay, pageViewIndex: pageViewIndex, date: date);
}

class RunningWorkoutDayFailure extends RunningWorkoutDayState {
  RunningWorkoutDayFailure({
    required WorkoutDay workoutDay,
    required int pageViewIndex,
    required DateTime date,
  }) : super(
          workoutDay: workoutDay,
          pageViewIndex: pageViewIndex,
          date: date,
        );
}

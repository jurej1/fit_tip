part of 'running_workout_day_bloc.dart';

abstract class RunningWorkoutDayState extends Equatable {
  const RunningWorkoutDayState(
    this.log,
    this.pageViewIndex,
  );

  final WorkoutDayLog log;
  final int pageViewIndex;

  int get pageViewLength => (log.excercises?.length ?? 0) + 1 + 1;

  @override
  List<Object> get props => [log, pageViewIndex];

  factory RunningWorkoutDayState.initial(DateTime focusedDate, WorkoutDay workoutDay, AuthenticationBloc authenticationBloc) {
    final now = DateTime.now();
    DateTime created = DateTime(focusedDate.year, focusedDate.month, focusedDate.day, now.hour, now.minute, now.second);

    return RunningWorkoutDayInitial(
      WorkoutDayLog(
        duration: Duration.zero,
        created: created,
        id: UniqueKey().toString(),
        workoutId: workoutDay.workoutId,
        excercises: workoutDay.excercises,
        userId: authenticationBloc.state.user!.uid!,
      ),
      0,
    );
  }
}

class RunningWorkoutDayInitial extends RunningWorkoutDayState {
  const RunningWorkoutDayInitial(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

class RunningWorkoutDayLoading extends RunningWorkoutDayState {
  const RunningWorkoutDayLoading(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

class RunningWorkoutDayLoadSuccess extends RunningWorkoutDayState {
  const RunningWorkoutDayLoadSuccess(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

class RunningWorkoutDayFail extends RunningWorkoutDayState {
  const RunningWorkoutDayFail(WorkoutDayLog log, int pageViewIndex) : super(log, pageViewIndex);
}

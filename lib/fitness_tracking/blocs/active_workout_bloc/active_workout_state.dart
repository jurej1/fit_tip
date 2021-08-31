part of 'active_workout_bloc.dart';

abstract class ActiveWorkoutState extends Equatable {
  const ActiveWorkoutState();

  @override
  List<Object> get props => [];

  factory ActiveWorkoutState.initial(WorkoutsListBloc workoutsListBloc) {
    if (workoutsListBloc is WorkoutsListFail) {
      return ActiveWorkoutFail();
    } else if (workoutsListBloc.state is WorkoutsListLoadSuccess) {
      final workoutListState = workoutsListBloc.state as WorkoutsListLoadSuccess;

      if (workoutListState.workouts.isEmpty) {
        return ActiveWorkoutNone();
      }

      final pureWorkout = Workout.pure();
      final Workout activeWorkout = workoutListState.workouts.firstWhere((element) => element.isActive, orElse: () => pureWorkout);

      if (activeWorkout != pureWorkout) {
        return ActiveWorkoutLoadSuccess(activeWorkout);
      } else {
        return ActiveWorkoutNone();
      }
    }

    return ActiveWorkoutLoading();
  }
}

class ActiveWorkoutLoading extends ActiveWorkoutState {}

class ActiveWorkoutLoadSuccess extends ActiveWorkoutState {
  final Workout workout;

  const ActiveWorkoutLoadSuccess(this.workout);

  @override
  List<Object> get props => [workout];
}

class ActiveWorkoutFail extends ActiveWorkoutState {}

class ActiveWorkoutNone extends ActiveWorkoutState {}

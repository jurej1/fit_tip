import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'active_workout_event.dart';
part 'active_workout_state.dart';

class ActiveWorkoutBloc extends Bloc<ActiveWorkoutEvent, ActiveWorkoutState> {
  ActiveWorkoutBloc() : super(ActiveWorkoutLoading());

  @override
  Stream<ActiveWorkoutState> mapEventToState(
    ActiveWorkoutEvent event,
  ) async* {
    if (event is _ActiveWorkoutFailureRquested) {
      yield ActiveWorkoutFail();
    } else if (event is _ActiveWorkoutListUpdated) {
      yield* _mapWorkoutsUpdatedToState(event);
    }
  }

  Stream<ActiveWorkoutState> _mapWorkoutsUpdatedToState(_ActiveWorkoutListUpdated event) async* {
    if (event.workouts.isEmpty) {
      yield ActiveWorkoutNone();
      return;
    }

    final pureWorkout = Workout.pure();
    final Workout activeWorkout = event.workouts.firstWhere((element) => element.isActive, orElse: () => pureWorkout);

    if (activeWorkout != pureWorkout) {
      yield ActiveWorkoutLoadSuccess(activeWorkout);
    } else {
      yield ActiveWorkoutNone();
    }
  }
}

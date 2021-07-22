import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'active_workout_event.dart';
part 'active_workout_state.dart';

class ActiveWorkoutBloc extends Bloc<ActiveWorkoutEvent, ActiveWorkoutState> {
  ActiveWorkoutBloc({
    required WorkoutsListBloc workoutsListBloc,
  })  : _workoutsListBloc = workoutsListBloc,
        super(ActiveWorkoutLoading()) {
    final listState = workoutsListBloc.state;

    if (listState is WorkoutsListLoadSuccess) {
      add(_ActiveWorkoutListUpdated(workouts: listState.workouts));
    } else if (listState is WorkoutsListFail) {
      add(_ActiveWorkoutFailureRquested());
    }

    _streamSubscription = _workoutsListBloc.stream.listen(
      (listState) {
        if (listState is WorkoutsListLoadSuccess) {
          add(_ActiveWorkoutListUpdated(workouts: listState.workouts));
        } else if (listState is WorkoutsListFail) {
          add(_ActiveWorkoutFailureRquested());
        }
      },
    );
  }

  late final StreamSubscription _streamSubscription;
  final WorkoutsListBloc _workoutsListBloc;

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

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs.dart';

part 'active_workout_focused_workout_day_event.dart';
part 'active_workout_focused_workout_day_state.dart';

class ActiveWorkoutFocusedWorkoutDayBloc extends Bloc<ActiveWorkoutFocusedWorkoutDayEvent, ActiveWorkoutFocusedWorkoutDayState> {
  ActiveWorkoutFocusedWorkoutDayBloc({
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
    required ActiveWorkoutBloc activeWorkoutBloc,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        _activeWorkoutBloc = activeWorkoutBloc,
        super(ActiveWorkoutFocusedWorkoutDayLoading()) {
    _streamSubscription = activeWorkoutBloc.stream.listen((activeState) {
      if (activeState is ActiveWorkoutFail) {
        add(_ActiveWorkoutFocusedWorkoutDayFailRequested());
      }
    });
  }

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  final ActiveWorkoutBloc _activeWorkoutBloc;

  late final StreamSubscription _streamSubscription;
  @override
  Stream<ActiveWorkoutFocusedWorkoutDayState> mapEventToState(
    ActiveWorkoutFocusedWorkoutDayEvent event,
  ) async* {
    if (event is _ActiveWorkoutFocusedWorkoutDayFailRequested) {
      yield ActiveWorkoutFocusedWorkoutDayFail();
    } else if (event is ActiveWorkoutFocusedWorkoutDayDayUpdated) {
      yield* _mapDayUpdatedToState(event);
    }
  }

  Stream<ActiveWorkoutFocusedWorkoutDayState> _mapDayUpdatedToState(ActiveWorkoutFocusedWorkoutDayDayUpdated event) async* {
    if (_activeWorkoutBloc.state is ActiveWorkoutLoadSuccess) {
      final activeState = _activeWorkoutBloc.state as ActiveWorkoutLoadSuccess;

      if (!activeState.workout.workouts.any((element) => element.day == event.date.weekday)) {
        yield ActiveWorkoutFocusedWorkoutDayLoadSuccess();
      } else {
        yield ActiveWorkoutFocusedWorkoutDayLoading();

        //Fetch the data from added workout,
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

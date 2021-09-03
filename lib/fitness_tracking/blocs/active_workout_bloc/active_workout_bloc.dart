import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'active_workout_event.dart';
part 'active_workout_state.dart';

class ActiveWorkoutBloc extends Bloc<ActiveWorkoutEvent, ActiveWorkoutState> {
  ActiveWorkoutBloc({
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(ActiveWorkoutLoading()) {
    final String uid = _authenticationBloc.state.user!.uid!;
    add(_ActiveWorkoutLoadRequested(_fitnessRepository.getActiveWorkoutId(uid)));
  }

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  //TODO when the workout gets updated here should also get updated
  @override
  Stream<ActiveWorkoutState> mapEventToState(
    ActiveWorkoutEvent event,
  ) async* {
    if (event is _ActiveWorkoutLoadRequested) {
      yield* _mapLoadRequestedToState(event);
    }
  }

  Stream<ActiveWorkoutState> _mapLoadRequestedToState(_ActiveWorkoutLoadRequested event) async* {
    if (event.id == null || !_authenticationBloc.state.isAuthenticated) {
      yield ActiveWorkoutNone();
      return;
    }

    yield ActiveWorkoutLoading();

    try {
      DocumentSnapshot documentSnapshot = await _fitnessRepository.getActiveWorkoutById(_authenticationBloc.state.user!.uid!, event.id!);
      ActiveWorkout active = ActiveWorkout.fromEntity(ActiveWorkoutEntity.fromDocumentSnapshot(documentSnapshot));
      yield ActiveWorkoutLoadSuccess(active);
    } catch (e) {
      yield ActiveWorkoutFail();
    }
  }
}

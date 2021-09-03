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
        super(ActiveWorkoutLoading());

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<ActiveWorkoutState> mapEventToState(
    ActiveWorkoutEvent event,
  ) async* {
    if (event is _ActiveWorkoutLoadRequested) {
      yield* _mapLoadRequestedToState(event);
    }
  }

  Stream<ActiveWorkoutState> _mapLoadRequestedToState(_ActiveWorkoutLoadRequested event) async* {
    if (event.id == null) {
      yield ActiveWorkoutNone();
      return;
    }

    yield ActiveWorkoutLoading();

    try {
      List<DocumentSnapshot> documents = await _fitnessRepository.getWorkoutById(event.id!);

      WorkoutInfo info = WorkoutInfo.fromEntiy(WorkoutInfoEntity.fromDocumentSnapshot(documents.first));
      WorkoutDays workoutDays = WorkoutDays.fromEntity(WorkoutDaysEntity.fromDocumentSnapshot(documents.last));

      Workout workout = Workout(
        info: info,
        isActive: true,
        workoutDays: workoutDays,
      );

      yield ActiveWorkoutLoadSuccess(workout);
    } catch (e) {
      yield ActiveWorkoutFail();
    }
  }
}

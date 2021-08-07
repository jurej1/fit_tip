import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_active_event.dart';
part 'workout_active_state.dart';

class WorkoutActiveBloc extends Bloc<WorkoutActiveEvent, WorkoutActiveState> {
  WorkoutActiveBloc({
    required WorkoutDay workoutDay,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : this._authenticationBloc = authenticationBloc,
        this._fitnessRepository = fitnessRepository,
        super(WorkoutActiveState(workoutDay: workoutDay));

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  @override
  Stream<WorkoutActiveState> mapEventToState(
    WorkoutActiveEvent event,
  ) async* {}
}

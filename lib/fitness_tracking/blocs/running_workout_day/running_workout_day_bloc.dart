import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'running_workout_day_event.dart';
part 'running_workout_day_state.dart';

class RunningWorkoutDayBloc extends Bloc<RunningWorkoutDayEvent, RunningWorkoutDayState> {
  RunningWorkoutDayBloc({
    required WorkoutDay workoutDay,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(RunningWorkoutDayState(workoutDay: workoutDay));

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  @override
  Stream<RunningWorkoutDayState> mapEventToState(
    RunningWorkoutDayEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

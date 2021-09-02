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
  ) async* {}
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_excercise_card_event.dart';
part 'workout_excercise_card_state.dart';

class WorkoutExcerciseCardBloc extends Bloc<WorkoutExcerciseCardEvent, WorkoutExcerciseCardState> {
  WorkoutExcerciseCardBloc({
    required WorkoutExcercise excercise,
  }) : super(WorkoutExcerciseCardState(excercise));

  @override
  Stream<WorkoutExcerciseCardState> mapEventToState(
    WorkoutExcerciseCardEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

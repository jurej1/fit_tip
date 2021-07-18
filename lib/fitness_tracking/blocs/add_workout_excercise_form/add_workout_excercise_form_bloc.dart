import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import '../../fitness_tracking.dart';
import 'package:equatable/equatable.dart';

part 'add_workout_excercise_form_event.dart';
part 'add_workout_excercise_form_state.dart';

class AddWorkoutExcerciseFormBloc extends Bloc<AddWorkoutExcerciseFormEvent, AddWorkoutExcerciseFormState> {
  AddWorkoutExcerciseFormBloc({WorkoutExcercise? workoutExcercis}) : super(AddWorkoutExcerciseFormState.initial(workoutExcercis));

  @override
  Stream<AddWorkoutExcerciseFormState> mapEventToState(
    AddWorkoutExcerciseFormEvent event,
  ) async* {
    if (event is AddWorkoutExcerciseNameUpdated) {
      yield* _mapNameUpdatedToState(event);
    } else if (event is AddWorkoutExcerciseSetsUpdated) {
      yield* _mapSetsUpdatedToState(event);
    } else if (event is AddWorkoutExcerciseRepsUpdated) {
      yield* _mapRepsUpdatedToState(event);
    } else if (event is AddWorkoutExcerciseRepUnitUpdated) {
      yield* _mapRepUnitUpdatedToState(event);
    } else if (event is AddWorkoutExcerciseFormSubmitted) {
      yield* _mapFormSubmitedToState(event);
    }
  }

  Stream<AddWorkoutExcerciseFormState> _mapNameUpdatedToState(AddWorkoutExcerciseNameUpdated event) async* {
    final name = WorkoutExcerciseName.dirty(event.value);

    yield state.copyWith(
      name: name,
      status: Formz.validate([
        name,
        state.repUnit,
        state.reps,
        state.sets,
      ]),
    );
  }

  Stream<AddWorkoutExcerciseFormState> _mapSetsUpdatedToState(AddWorkoutExcerciseSetsUpdated event) async* {
    final sets = WorkoutExcerciseIntFormz.dirty(event.value);

    yield state.copyWith(
      sets: sets,
      status: Formz.validate([
        sets,
        state.name,
        state.repUnit,
        state.reps,
      ]),
    );
  }

  Stream<AddWorkoutExcerciseFormState> _mapRepsUpdatedToState(AddWorkoutExcerciseRepsUpdated event) async* {
    final reps = WorkoutExcerciseIntFormz.dirty(event.value);

    yield state.copyWith(
      reps: reps,
      status: Formz.validate([reps, state.name, state.repUnit, state.sets]),
    );
  }

  Stream<AddWorkoutExcerciseFormState> _mapRepUnitUpdatedToState(AddWorkoutExcerciseRepUnitUpdated event) async* {
    final repUnit = WorkoutRepUnit.dirty(event.value);

    yield state.copyWith(
      repUnit: repUnit,
      status: Formz.validate([repUnit, state.name, state.reps, state.sets]),
    );
  }

  Stream<AddWorkoutExcerciseFormState> _mapFormSubmitedToState(AddWorkoutExcerciseFormSubmitted event) async* {
    final repUnit = WorkoutRepUnit.dirty(state.repUnit.value);
    final name = WorkoutExcerciseName.dirty(state.name.value);
    final reps = WorkoutExcerciseIntFormz.dirty(state.reps.value);
    final sets = WorkoutExcerciseIntFormz.dirty(state.sets.value);

    yield state.copyWith(
      repUnit: repUnit,
      name: name,
      reps: reps,
      sets: sets,
      status: Formz.validate([repUnit, name, reps, sets]),
    );

    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/fitness_tracking/models/workout_muscle_group_list.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part 'add_workout_day_form_event.dart';
part 'add_workout_day_form_state.dart';

class AddWorkoutDayFormBloc extends Bloc<AddWorkoutDayFormEvent, AddWorkoutDayFormState> {
  AddWorkoutDayFormBloc({
    required WorkoutDay workoutDay,
  }) : super(AddWorkoutDayFormState.initial(workoutDay));

  @override
  Stream<AddWorkoutDayFormState> mapEventToState(
    AddWorkoutDayFormEvent event,
  ) async* {
    if (event is AddWorkoutDayDayChanged) {
      yield* _mapDayChangedToState(event);
    } else if (event is AddWorkoutDayNoteChanged) {
      yield* _mapNoteChangedToState(event);
    } else if (event is AddWorkoutDayMuscleGroupAdded) {
      yield* _mapMuscleGroupAddedToState(event);
    } else if (event is AddWorkoutDayMuscleGroupRemoved) {
      yield* _mapMuscleGroupRemovedToState(event);
    } else if (event is AddWorkoutDayExcerciseAdded) {
      yield* _mapExcerciseAddedToState(event);
    } else if (event is AddWorkoutDayExcerciseRemoved) {
      yield* _mapExcerciseRemovedToState(event);
    } else if (event is AddWorkoutDayExcerciseUpdated) {
      yield* _mapExcerciseUpdatedToState(event);
    } else if (event is AddWorkoutDayFormSubmited) {
      yield* _mapFormSubmitedToState(event);
    }
  }

  Stream<AddWorkoutDayFormState> _mapDayChangedToState(AddWorkoutDayDayChanged event) async* {
    if (event.value != null) {
      final day = WorkoutDayDay.dirty(event.value!);

      yield state.copyWith(
        day: day,
        status: Formz.validate([
          day,
          state.muscleGroupList,
          state.note,
          state.workoutExcercisesList,
        ]),
      );
    }
  }

  Stream<AddWorkoutDayFormState> _mapNoteChangedToState(AddWorkoutDayNoteChanged event) async* {
    final note = WorkoutNote.dirty(event.value);

    yield state.copyWith(
      note: note,
      status: Formz.validate([
        note,
        state.day,
        state.muscleGroupList,
        state.workoutExcercisesList,
      ]),
    );
  }

  Stream<AddWorkoutDayFormState> _mapMuscleGroupAddedToState(AddWorkoutDayMuscleGroupAdded event) async* {
    if (event.value == null) return;

    List<MuscleGroup>? muscleGroupList = state.muscleGroupList.value;

    if (muscleGroupList == null) {
      muscleGroupList = [event.value!];
    } else {
      muscleGroupList.add(event.value!);
    }

    final list = WorkoutMuscleGroupList.dirty(muscleGroupList);

    yield state.copyWith(
      muscleGroupList: list,
      status: Formz.validate([
        list,
        state.day,
        state.note,
        state.workoutExcercisesList,
      ]),
    );
  }

  Stream<AddWorkoutDayFormState> _mapMuscleGroupRemovedToState(AddWorkoutDayMuscleGroupRemoved event) async* {
    List<MuscleGroup>? muscleGroupList = state.muscleGroupList.value;

    if (muscleGroupList == null) return;

    muscleGroupList.remove(event.value);

    final list = WorkoutMuscleGroupList.dirty(muscleGroupList);

    yield state.copyWith(
      muscleGroupList: list,
      status: Formz.validate([
        list,
        state.day,
        state.note,
        state.workoutExcercisesList,
      ]),
    );
  }

  Stream<AddWorkoutDayFormState> _mapExcerciseAddedToState(AddWorkoutDayExcerciseAdded event) async* {
    List<WorkoutExcercise> excercises = List.from(state.workoutExcercisesList.value);

    excercises.add(event.value);

    final list = WorkoutExcercisesList.dirty(excercises);

    yield state.copyWith(
      workoutExcercisesList: list,
      status: Formz.validate([
        list,
        state.day,
        state.muscleGroupList,
        state.note,
      ]),
    );
  }

  Stream<AddWorkoutDayFormState> _mapExcerciseRemovedToState(AddWorkoutDayExcerciseRemoved event) async* {
    List<WorkoutExcercise> excercises = List.from(state.workoutExcercisesList.value);

    excercises.remove(event.value);

    final list = WorkoutExcercisesList.dirty(excercises);

    yield state.copyWith(
      workoutExcercisesList: list,
      status: Formz.validate([
        list,
        state.day,
        state.muscleGroupList,
        state.note,
      ]),
    );
  }

  Stream<AddWorkoutDayFormState> _mapExcerciseUpdatedToState(AddWorkoutDayExcerciseUpdated event) async* {
    List<WorkoutExcercise> excercises = List.from(state.workoutExcercisesList.value);

    excercises = excercises.map((e) {
      if (e.id == event.value.id) return event.value;
      return e;
    }).toList();

    final list = WorkoutExcercisesList.dirty(excercises);

    yield state.copyWith(
      workoutExcercisesList: list,
      status: Formz.validate([
        list,
        state.day,
        state.muscleGroupList,
        state.note,
      ]),
    );
  }

  Stream<AddWorkoutDayFormState> _mapFormSubmitedToState(AddWorkoutDayFormSubmited event) async* {
    final day = WorkoutDayDay.dirty(state.day.value);
    final note = WorkoutNote.dirty(state.note.value);
    final muscleGroupList = WorkoutMuscleGroupList.dirty(state.muscleGroupList.value);
    final workoutExcerciseList = WorkoutExcercisesList.dirty(state.workoutExcercisesList.value);

    yield state.copyWith(
      day: day,
      note: note,
      muscleGroupList: muscleGroupList,
      workoutExcercisesList: workoutExcerciseList,
      status: Formz.validate([
        day,
        note,
        muscleGroupList,
        workoutExcerciseList,
      ]),
    );

    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }
}

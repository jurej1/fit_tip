import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

part 'add_workout_form_event.dart';
part 'add_workout_form_state.dart';

class AddWorkoutFormBloc extends Bloc<AddWorkoutFormEvent, AddWorkoutFormState> {
  AddWorkoutFormBloc() : super(AddWorkoutFormState.initial());

  @override
  Stream<AddWorkoutFormState> mapEventToState(
    AddWorkoutFormEvent event,
  ) async* {
    if (event is AddWorkoutFormGoalUpdated) {
      yield* _mapGoalUpdatedToState(event);
    } else if (event is AddWorkoutFormTypeUpdated) {
      yield* _mapTypeUpdatedToState(event);
    } else if (event is AddWorkoutFormDurationUpdated) {
      yield* _mapDurationUpdatedToState(event);
    } else if (event is AddWorkoutFormDaysPerWeekUpdated) {
      yield* _mapDaysPerWeekUpdatedToState(event);
    } else if (event is AddWorkoutFormTimePerWorkoutUpdated) {
      yield* _mapTimePerWorkoutUpdatedToState(event);
    } else if (event is AddWorkoutFormStartDateUpdated) {
      yield* _mapStartDateUpdatedToState(event);
    } else if (event is AddWorkoutFormSubmitted) {
      yield* _mapFormSubmitToState();
    }
  }

  Stream<AddWorkoutFormState> _mapGoalUpdatedToState(AddWorkoutFormGoalUpdated event) async* {
    if (event.value != null) {
      final goal = WorkoutGoalFormz.dirty(event.value!);

      yield state.copyWith(
        goal: goal,
        status: Formz.validate([
          goal,
          state.daysPerWeek,
          state.duration,
          state.startDate,
          state.timePerWorkout,
          state.type,
        ]),
      );
    }
  }

  Stream<AddWorkoutFormState> _mapTypeUpdatedToState(AddWorkoutFormTypeUpdated event) async* {
    if (event.value != null) {
      final type = WorkoutTypeFormz.dirty(event.value!);

      yield state.copyWith(
        type: type,
        status: Formz.validate([
          type,
          state.daysPerWeek,
          state.duration,
          state.goal,
          state.startDate,
          state.timePerWorkout,
        ]),
      );
    }
  }

  Stream<AddWorkoutFormState> _mapDurationUpdatedToState(AddWorkoutFormDurationUpdated event) async* {
    final duration = WorkoutIntFormz.dirty(event.value);
    yield state.copyWith(
      duration: duration,
      status: Formz.validate([
        duration,
        state.daysPerWeek,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapDaysPerWeekUpdatedToState(AddWorkoutFormDaysPerWeekUpdated event) async* {
    final daysPerWeek = WorkoutIntFormz.dirty(event.value);

    yield state.copyWith(
      daysPerWeek: daysPerWeek,
      status: Formz.validate([
        daysPerWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapTimePerWorkoutUpdatedToState(AddWorkoutFormTimePerWorkoutUpdated event) async* {
    final timePerWorkout = WorkoutIntFormz.dirty(event.value);

    yield state.copyWith(
      timePerWorkout: timePerWorkout,
      status: Formz.validate([
        timePerWorkout,
        state.daysPerWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.type,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapStartDateUpdatedToState(AddWorkoutFormStartDateUpdated event) async* {
    if (event.value != null) {
      final startDate = WorkoutDateFormz.dirty(event.value);

      yield state.copyWith(
        startDate: startDate,
        status: Formz.validate(
          [
            startDate,
            state.daysPerWeek,
            state.duration,
            state.goal,
            state.timePerWorkout,
            state.type,
          ],
        ),
      );
    }
  }

  Stream<AddWorkoutFormState> _mapFormSubmitToState() async* {
    final goal = WorkoutGoalFormz.dirty(state.goal.value);
    final type = WorkoutTypeFormz.dirty(state.type.value);
    final duration = WorkoutIntFormz.dirty(state.duration.value);
    final daysPerWeek = WorkoutIntFormz.dirty(state.daysPerWeek.value);
    final timePerWorkout = WorkoutIntFormz.dirty(state.daysPerWeek.value);
    final startDate = WorkoutDateFormz.dirty(state.startDate.value);

    yield state.copyWith(
      goal: goal,
      type: type,
      duration: duration,
      daysPerWeek: daysPerWeek,
      timePerWorkout: timePerWorkout,
      startDate: startDate,
      status: Formz.validate([goal, type, duration, daysPerWeek, timePerWorkout, startDate]),
    );

    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }
}

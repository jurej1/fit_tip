import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

part 'add_workout_form_event.dart';
part 'add_workout_form_state.dart';

class AddWorkoutFormBloc extends Bloc<AddWorkoutFormEvent, AddWorkoutFormState> {
  AddWorkoutFormBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    Workout? workout,
  })  : _fitnessRepository = fitnessRepository,
        super(AddWorkoutFormState.initial(workout)) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final FitnessRepository _fitnessRepository;
  late final StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
    } else if (event is AddWorkoutFormListItemAdded) {
      yield* _mapItemAddedToState(event);
    } else if (event is AddWorkoutFormListItemRemoved) {
      yield* _mapItemRemovedToState(event);
    } else if (event is AddWorkoutFormListItemUpdated) {
      yield* _mapItemUpdatedToState(event);
    } else if (event is AddWorkoutFormNoteUpdated) {
      yield* _mapNoteUpdatedToState(event);
    } else if (event is AddWorkoutFormSubmitted) {
      yield* _mapFormSubmitToState();
    } else if (event is AddWorkoutFormTitleUpdated) {
      yield* _mapTitleUpdatedToState(event);
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
          state.workoutDays,
          state.note,
          state.title,
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
          state.workoutDays,
          state.note,
          state.title,
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
        state.workoutDays,
        state.note,
        state.title,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapDaysPerWeekUpdatedToState(AddWorkoutFormDaysPerWeekUpdated event) async* {
    final int oldAmount = state.daysPerWeek.getIntValue();

    final daysPerWeek = WorkoutIntFormz.dirty(event.value);
    final int eventAmount = daysPerWeek.getIntValue();

    int diff = (oldAmount - eventAmount).abs();

    final List<WorkoutDay> currentWorkoutDays = state.workoutDays.value;
    List<WorkoutDay> newList = const [];

    if (eventAmount == 0) {
      final workoutDays = WorkoutDaysList.dirty(workoutsPerWeekend: eventAmount, value: newList);
      yield state.copyWith(
        workoutDays: workoutDays,
        daysPerWeek: daysPerWeek,
        status: Formz.validate([
          workoutDays,
          daysPerWeek,
          state.duration,
          state.goal,
          state.startDate,
          state.timePerWorkout,
          state.type,
          state.note,
          state.title,
        ]),
      );
    } else if (eventAmount > oldAmount) {
      if (currentWorkoutDays.isEmpty) {
        newList = List.generate(diff, WorkoutDay.fromListIndexToPure);
      } else {
        if (diff == 1) {
          newList.add(WorkoutDay.fromListIndexToPure(newList.length));
        } else {
          newList.addAll(List.generate(diff, (index) => WorkoutDay.fromListIndexToPure(index + newList.length)));
        }
      }
    } else if (eventAmount < oldAmount) {
      newList = List.from(currentWorkoutDays);

      for (int i = newList.length - 1; i > diff; i--) {
        newList.removeAt(i);
      }
    }
    final workoutDays = WorkoutDaysList.dirty(workoutsPerWeekend: eventAmount, value: newList);
    yield state.copyWith(
      daysPerWeek: daysPerWeek,
      workoutDays: workoutDays,
      status: Formz.validate([
        workoutDays,
        daysPerWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
        state.note,
        state.title,
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
        state.workoutDays,
        state.note,
        state.title,
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
            state.workoutDays,
            state.note,
            state.title,
          ],
        ),
      );
    }
  }

  Stream<AddWorkoutFormState> _mapItemAddedToState(AddWorkoutFormListItemAdded event) async* {
    final items = state.workoutDays.value;

    items.add(event.value);
    final workoutDays = WorkoutDaysList.dirty(value: items, workoutsPerWeekend: state.daysPerWeek.getIntValue());

    yield state.copyWith(
      workoutDays: workoutDays,
      status: Formz.validate([
        workoutDays,
        state.daysPerWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
        state.note,
        state.title,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapItemRemovedToState(AddWorkoutFormListItemRemoved event) async* {
    List<WorkoutDay> items = state.workoutDays.value;

    items.removeWhere((element) => element.id == event.value.id);

    final workoutDaysList = WorkoutDaysList.dirty(
      value: items,
      workoutsPerWeekend: state.daysPerWeek.getIntValue(),
    );

    int workoutsPerWeek = state.daysPerWeek.getIntValue();

    workoutsPerWeek -= 1;

    final WorkoutIntFormz perWeek = WorkoutIntFormz.dirty(workoutsPerWeek.toStringAsFixed(0));

    yield state.copyWith(
      workoutDays: workoutDaysList,
      daysPerWeek: perWeek,
      status: Formz.validate([
        workoutDaysList,
        perWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
        state.note,
        state.title,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapItemUpdatedToState(AddWorkoutFormListItemUpdated event) async* {
    List<WorkoutDay> items = state.workoutDays.value;

    items = items.map((e) {
      if (e.id == event.value.id) {
        return event.value;
      }
      return e;
    }).toList();

    final workoutDays = WorkoutDaysList.dirty(
      value: items,
      workoutsPerWeekend: state.daysPerWeek.getIntValue(),
    );

    yield state.copyWith(
      workoutDays: workoutDays,
      status: Formz.validate([
        workoutDays,
        state.daysPerWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
        state.note,
        state.title,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapNoteUpdatedToState(AddWorkoutFormNoteUpdated event) async* {
    final note = WorkoutNote.dirty(event.value);

    yield state.copyWith(
      note: note,
      status: Formz.validate([
        note,
        state.daysPerWeek,
        state.duration,
        state.goal,
        state.startDate,
        state.timePerWorkout,
        state.type,
        state.workoutDays,
        state.title,
      ]),
    );
  }

  Stream<AddWorkoutFormState> _mapFormSubmitToState() async* {
    final goal = WorkoutGoalFormz.dirty(state.goal.value);
    final type = WorkoutTypeFormz.dirty(state.type.value);
    final duration = WorkoutIntFormz.dirty(state.duration.value);
    final daysPerWeek = WorkoutIntFormz.dirty(state.daysPerWeek.value);
    final timePerWorkout = WorkoutIntFormz.dirty(state.daysPerWeek.value);
    final startDate = WorkoutDateFormz.dirty(state.startDate.value);
    final workoutDays = WorkoutDaysList.dirty(value: state.workoutDays.value, workoutsPerWeekend: daysPerWeek.getIntValue());
    final note = WorkoutNote.dirty(state.note.value);
    final title = WorkoutTitle.dirty(state.title.value);

    yield state.copyWith(
      workoutDays: workoutDays,
      title: title,
      goal: goal,
      note: note,
      type: type,
      duration: duration,
      daysPerWeek: daysPerWeek,
      timePerWorkout: timePerWorkout,
      startDate: startDate,
      status: Formz.validate([goal, type, duration, daysPerWeek, timePerWorkout, startDate, workoutDays, note, title]),
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        if (state.formMode == FormMode.add) {
          DocumentReference ref = await _fitnessRepository.addWorkout(_userId!, state.workout);
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            id: ref.id,
            workoutDays: WorkoutDaysList.dirty(
              // TODO test this three lines
              value: state.workoutDays.value.map((e) => e.copyWith(workoutId: ref.id)).toList(),
              workoutsPerWeekend: state.daysPerWeek.getIntValue(),
            ),
          );
        } else {
          await _fitnessRepository.updateWorkout(_userId!, state.workout);
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        }
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  Stream<AddWorkoutFormState> _mapTitleUpdatedToState(AddWorkoutFormTitleUpdated event) async* {
    final title = WorkoutTitle.dirty(event.value);

    yield state.copyWith(
      title: title,
      status: Formz.validate([
        title,
        state.daysPerWeek,
        state.duration,
        state.goal,
        state.note,
        state.startDate,
        state.timePerWorkout,
        state.type,
        state.workoutDays,
      ]),
    );
  }
}

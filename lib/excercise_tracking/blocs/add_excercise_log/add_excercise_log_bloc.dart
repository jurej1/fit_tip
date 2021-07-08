import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/excercise_tracking/models/models.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

part 'add_excercise_log_event.dart';
part 'add_excercise_log_state.dart';

class AddExcerciseLogBloc extends Bloc<AddExcerciseLogEvent, AddExcerciseLogState> {
  AddExcerciseLogBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessREpository,
    required DaySelectorBloc daySelectorBloc,
    ExcerciseLog? excerciseLog,
  })  : _fitnessRepository = fitnessREpository,
        _authenticationBloc = authenticationBloc,
        super(excerciseLog == null
            ? AddExcerciseLogState.initial(daySelectorBloc.state.selectedDate)
            : AddExcerciseLogState.edit(excerciseLog));

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<AddExcerciseLogState> mapEventToState(
    AddExcerciseLogEvent event,
  ) async* {
    if (event is AddExcerciseLogDurationUpdated) {
      yield* _mapDurationUpdatedToState(event);
    } else if (event is AddExcerciseLogNameUpdated) {
      yield* _mapNameUpdatedToState(event);
    } else if (event is AddExcerciseLogIntensityUpdated) {
      yield* _mapIntensityUpdatedToState(event);
    } else if (event is AddExcerciseLogCaloriesUpdated) {
      yield* _mapCalorieUpdatedToState(event);
    } else if (event is AddExcerciseLogTimeUpdated) {
      yield* _mapTimeUpatedToState(event);
    } else if (event is AddExcerciseLogDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is AddExcerciseLogTypeUpdated) {
      yield* _mapTypeUpdatedToState(event);
    } else if (event is AddExcerciseLogFormSubmit) {
      yield* _mapFormSubmitToState();
    }
  }

  Stream<AddExcerciseLogState> _mapDurationUpdatedToState(AddExcerciseLogDurationUpdated event) async* {
    final duration = ExcerciseDuration.dirty(event.value);

    yield state.copyWith(
      duration: duration,
      status: Formz.validate([duration, state.calories, state.date, state.intensity, state.name, state.time, state.type]),
    );
  }

  Stream<AddExcerciseLogState> _mapNameUpdatedToState(AddExcerciseLogNameUpdated event) async* {
    final name = ExcerciseName.dirty(event.value);

    yield state.copyWith(
      name: name,
      status: Formz.validate([name, state.calories, state.date, state.duration, state.intensity, state.time, state.type]),
    );
  }

  Stream<AddExcerciseLogState> _mapIntensityUpdatedToState(AddExcerciseLogIntensityUpdated event) async* {
    if (event.value != null) {
      final intensity = ExcerciseIntensity.dirty(event.value!);

      yield state.copyWith(
        intensity: intensity,
        status: Formz.validate([intensity, state.calories, state.date, state.duration, state.name, state.time, state.type]),
      );
    }
  }

  Stream<AddExcerciseLogState> _mapCalorieUpdatedToState(AddExcerciseLogCaloriesUpdated event) async* {
    final calorie = ExcerciseCalories.dirty(event.value);

    yield state.copyWith(
      calories: calorie,
      status: Formz.validate([calorie, state.date, state.duration, state.intensity, state.name, state.time, state.type]),
    );
  }

  Stream<AddExcerciseLogState> _mapTimeUpatedToState(AddExcerciseLogTimeUpdated event) async* {
    if (event.value != null) {
      final time = ExcerciseStartTime.dirty(event.value);

      yield state.copyWith(
        time: time,
        status: Formz.validate([time, state.calories, state.date, state.duration, state.intensity, state.name, state.time, state.type]),
      );
    }
  }

  Stream<AddExcerciseLogState> _mapDateUpdatedToState(AddExcerciseLogDateUpdated event) async* {
    if (event.value != null) {
      final date = ExcerciseStartDate.dirty(event.value);

      yield state.copyWith(
        date: date,
        status: Formz.validate([date, state.calories, state.duration, state.intensity, state.name, state.time, state.type]),
      );
    }
  }

  Stream<AddExcerciseLogState> _mapTypeUpdatedToState(AddExcerciseLogTypeUpdated event) async* {
    if (event.type != null) {
      final type = ExcerciseTypeInput.dirty(event.type!);

      yield state.copyWith(
        type: type,
        status: Formz.validate([type, state.calories, state.date, state.duration, state.intensity, state.name, state.time]),
      );
    }
  }

  Stream<AddExcerciseLogState> _mapFormSubmitToState() async* {
    final calorie = ExcerciseCalories.dirty(state.calories.value);
    final duration = ExcerciseDuration.dirty(state.duration.value);
    final date = ExcerciseStartDate.dirty(state.date.value);
    final time = ExcerciseStartTime.pure(state.time.value);
    final intensity = ExcerciseIntensity.dirty(state.intensity.value);
    final name = ExcerciseName.dirty(state.name.value);
    final type = ExcerciseTypeInput.dirty(state.type.value);

    yield state.copyWith(
      calories: calorie,
      duration: duration,
      date: date,
      time: time,
      intensity: intensity,
      name: name,
      type: type,
      status: Formz.validate([calorie, duration, date, time, intensity, name, type]),
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        if (state.mode == FormMode.add) {
          DocumentReference ref = await _fitnessRepository.addExcerciseLog(
            _user!.id!,
            state.excerciseLog,
          );

          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            id: ref.id,
          );
        } else if (state.mode == FormMode.edit) {
          await _fitnessRepository.updateExcerciseLog(
            _user!.id!,
            state.excerciseLog,
          );
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        }
      } catch (error) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}

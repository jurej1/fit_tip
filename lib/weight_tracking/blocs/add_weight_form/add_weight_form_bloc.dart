import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/enums/enums.dart';
import 'package:fit_tip/weight_tracking/weight.dart' as model;
import 'package:flutter/material.dart';

import 'package:formz/formz.dart';
import 'package:weight_repository/weight_repository.dart';

part 'add_weight_form_event.dart';
part 'add_weight_form_state.dart';

class AddWeightFormBloc extends Bloc<AddWeightFormEvent, AddWeightFormState> {
  AddWeightFormBloc({
    required WeightRepository weightRepository,
    required AuthenticationBloc authenticationBloc,
    Weight? weight,
  })  : _weightRepository = weightRepository,
        _authenticationBloc = authenticationBloc,
        super(weight == null ? AddWeightFormState.initial() : AddWeightFormState.edit(weight));

  final WeightRepository _weightRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get isAuth => _authenticationBloc.state.isAuthenticated;
  User? get user => _authenticationBloc.state.user;

  @override
  Stream<AddWeightFormState> mapEventToState(
    AddWeightFormEvent event,
  ) async* {
    if (event is AddWeightDateChanged) {
      yield _mapDateChangedToState(event);
    } else if (event is AddWeightWeightChanged) {
      yield _mapWeightChangedToState(event);
    } else if (event is AddWeightFormSubit) {
      yield* _mapFormSubitToState();
    } else if (event is AddWeightTimeChanged) {
      yield _mapTimeChangedToState(event);
    }
  }

  AddWeightFormState _mapDateChangedToState(AddWeightDateChanged event) {
    final date = model.DateAdded.dirty(event.value);

    return state.copyWith(
      dateAdded: date,
      status: Formz.validate([date, state.weight, state.timeAdded]),
    );
  }

  AddWeightFormState _mapWeightChangedToState(AddWeightWeightChanged event) {
    final weight = model.Weight.dirty(event.value);

    return state.copyWith(
      weight: weight,
      status: Formz.validate([weight, state.dateAdded, state.weight]),
    );
  }

  AddWeightFormState _mapTimeChangedToState(AddWeightTimeChanged event) {
    final time = model.TimeAdded.dirty(event.value, state.dateAdded.value);

    return state.copyWith(
      timeAdded: time,
      status: Formz.validate([time, state.dateAdded, state.weight]),
    );
  }

  Stream<AddWeightFormState> _mapFormSubitToState() async* {
    final date = model.DateAdded.dirty(state.dateAdded.value);
    final weight = model.Weight.dirty(state.weight.value);
    final time = model.TimeAdded.dirty(state.timeAdded.value, date.value);

    yield state.copyWith(
      dateAdded: date,
      weight: weight,
      timeAdded: time,
      status: Formz.validate([date, weight, time]),
    );

    if (state.status.isValidated && isAuth) {
      final user = _authenticationBloc.state.user;

      try {
        double weightValue = double.parse(state.weight.value);
        if (user!.measurmentSystem != MeasurmentSystem.metric) weightValue = MeasurmentSystemConverter.lbTokg(weightValue);

        final stateDate = state.dateAdded.value;
        final stateTime = state.timeAdded.value;

        final date = DateTime(stateDate.year, stateDate.month, stateDate.day, stateTime.hour, stateTime.minute);

        Weight weight = Weight(
          date: date,
          weight: weightValue,
        );

        if (state.mode == FormMode.add) {
          final doc = await _weightRepository.addWeight(user.id!, weight);
          weight = weight.copyWith(id: doc.id);
        } else if (state.mode == FormMode.edit) {
          await _weightRepository.updateWeight(user.id!, weight.copyWith(id: state.weightModel!.id));
        }

        yield state.copyWith(status: FormzStatus.submissionSuccess, weightModel: weight);
      } catch (error) {
        yield state.copyWith(status: FormzStatus.submissionFailure, errorMsg: error.toString());
      }
    }
  }
}

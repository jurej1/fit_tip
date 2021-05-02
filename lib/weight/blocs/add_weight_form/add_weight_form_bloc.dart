import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/weight/models/models.dart' as model;
import 'package:formz/formz.dart';
import 'package:weight_repository/weight_repository.dart';

part 'add_weight_form_event.dart';
part 'add_weight_form_state.dart';

class AddWeightFormBloc extends Bloc<AddWeightFormEvent, AddWeightFormState> {
  AddWeightFormBloc({
    required WeightRepository weightRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _weightRepository = weightRepository,
        _authenticationBloc = authenticationBloc,
        super(AddWeightFormState.initial());

  final WeightRepository _weightRepository;
  final AuthenticationBloc _authenticationBloc;

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
    }
  }

  AddWeightFormState _mapDateChangedToState(AddWeightDateChanged event) {
    final date = model.DateAdded.dirty(event.value);

    return state.copyWith(
      dateAdded: date,
      status: Formz.validate([date, state.weight]),
    );
  }

  AddWeightFormState _mapWeightChangedToState(AddWeightWeightChanged event) {
    final weight = model.Weight.dirty(event.value);

    return state.copyWith(
      weight: weight,
      status: Formz.validate([weight, state.dateAdded]),
    );
  }

  Stream<AddWeightFormState> _mapFormSubitToState() async* {
    final date = model.DateAdded.dirty(state.dateAdded.value);
    final weight = model.Weight.dirty(state.weight.value);

    yield state.copyWith(
      dateAdded: date,
      weight: weight,
      status: Formz.validate([date, weight]),
    );

    if (state.status.isValidated && _authenticationBloc.state.status == AuthenticationStatus.authenticated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        Weight weight = Weight(
          date: state.dateAdded.value,
          weight: double.parse(state.weight.value),
        );

        final id = await _weightRepository.addWeight(
          Weight(
            date: state.dateAdded.value,
            weight: double.parse(state.weight.value),
          ),
        );
        weight = weight.copyWith(id: id?.id);

        yield state.copyWith(status: FormzStatus.submissionSuccess, weightModel: weight);
      } catch (error) {
        yield state.copyWith(status: FormzStatus.submissionFailure, errorMsg: error.toString());
      }
    }
  }
}

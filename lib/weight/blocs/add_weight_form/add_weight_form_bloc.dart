import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/weight/models/models.dart' as model;
import 'package:formz/formz.dart';

part 'add_weight_form_event.dart';
part 'add_weight_form_state.dart';

class AddWeightFormBloc extends Bloc<AddWeightFormEvent, AddWeightFormState> {
  AddWeightFormBloc() : super(AddWeightFormState.initial());

  @override
  Stream<AddWeightFormState> mapEventToState(
    AddWeightFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/models/models.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'add_vitamin_form_event.dart';
part 'add_vitamin_form_state.dart';

class AddVitaminFormBloc extends Bloc<AddVitaminFormEvent, AddVitaminFormState> {
  AddVitaminFormBloc({
    double? amount,
    Vitamin? vitamin,
  }) : super(AddVitaminFormState.pure(amount: amount, vitamin: vitamin));

  @override
  Stream<AddVitaminFormState> mapEventToState(
    AddVitaminFormEvent event,
  ) async* {}
}

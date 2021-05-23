import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'add_water_log_form_event.dart';
part 'add_water_log_form_state.dart';

class AddWaterLogFormBloc extends Bloc<AddWaterLogFormEvent, AddWaterLogFormState> {
  AddWaterLogFormBloc() : super(AddWaterLogFormState());

  @override
  Stream<AddWaterLogFormState> mapEventToState(
    AddWaterLogFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

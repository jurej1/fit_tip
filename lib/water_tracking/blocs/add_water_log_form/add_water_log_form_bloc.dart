import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/water_tracking/models/models.dart';
import 'package:fit_tip/weight_tracking/models/models.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:water_repository/enums/enums.dart';

part 'add_water_log_form_event.dart';
part 'add_water_log_form_state.dart';

class AddWaterLogFormBloc extends Bloc<AddWaterLogFormEvent, AddWaterLogFormState> {
  AddWaterLogFormBloc() : super(AddWaterLogFormState.pure());

  @override
  Stream<AddWaterLogFormState> mapEventToState(
    AddWaterLogFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

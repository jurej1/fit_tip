import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'add_excercise_log_event.dart';
part 'add_excercise_log_state.dart';

class AddExcerciseLogBloc extends Bloc<AddExcerciseLogEvent, AddExcerciseLogState> {
  AddExcerciseLogBloc() : super(AddExcerciseLogState());

  @override
  Stream<AddExcerciseLogState> mapEventToState(
    AddExcerciseLogEvent event,
  ) async* {
    if (event is AddExcerciseLogDurationUpdated) {
      // final ScrollController controller = event.controller;
      // final int offset = controller.offset.toInt();

      // double index = offset / event.itemWidth;

      // yield state.copyWith(
      //   focusedIndex: index.round(),
      // );
    }
  }
}

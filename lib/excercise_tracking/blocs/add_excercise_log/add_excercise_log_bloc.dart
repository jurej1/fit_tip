import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_excercise_log_event.dart';
part 'add_excercise_log_state.dart';

class AddExcerciseLogBloc extends Bloc<AddExcerciseLogEvent, AddExcerciseLogState> {
  AddExcerciseLogBloc() : super(AddExcerciseLogState());

  @override
  Stream<AddExcerciseLogState> mapEventToState(
    AddExcerciseLogEvent event,
  ) async* {
    if (event is AddExcerciseLogDurationUpdated) {
      yield state.copyWith(offset: event.offset);
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'excercise_page_card_event.dart';
part 'excercise_page_card_state.dart';

class ExcercisePageCardBloc extends Bloc<ExcercisePageCardEvent, ExcercisePageCardState> {
  ExcercisePageCardBloc({
    required WorkoutExcercise excercise,
  }) : super(ExcercisePageCardState(excercise: excercise));

  @override
  Stream<ExcercisePageCardState> mapEventToState(
    ExcercisePageCardEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

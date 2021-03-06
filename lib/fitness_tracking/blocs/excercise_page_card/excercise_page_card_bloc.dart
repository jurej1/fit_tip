import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'excercise_page_card_event.dart';
part 'excercise_page_card_state.dart';

class ExcercisePageCardBloc extends Bloc<ExcercisePageCardEvent, ExcercisePageCardState> {
  ExcercisePageCardBloc({
    required WorkoutExcercise excercise,
  }) : super(ExcercisePageCardState.pure(excercise));

  @override
  Stream<ExcercisePageCardState> mapEventToState(
    ExcercisePageCardEvent event,
  ) async* {
    if (event is ExcercisePageRepCountUpdated) {
      yield* _mapRepCountUpdatedToState(event);
    } else if (event is ExcercisePageWeightCountUpdated) {
      yield* _mapWeightCountUpdatedToState(event);
    }
  }

  Stream<ExcercisePageCardState> _mapWeightCountUpdatedToState(ExcercisePageWeightCountUpdated event) async* {
    final int index = event.setIndex;
    final List<double> weightCount = List.from(state.weightCount);
    weightCount[index] = event.value;
    yield state.copyWith(weightCount: weightCount);
  }

  Stream<ExcercisePageCardState> _mapRepCountUpdatedToState(ExcercisePageRepCountUpdated event) async* {
    final int index = event.setIndex;
    final List<int> repsCount = List.from(state.repsCount);
    repsCount[index] = event.value;
    yield state.copyWith(repsCount: repsCount);
  }
}

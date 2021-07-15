import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'rep_unit_value_selector_event.dart';
part 'rep_unit_value_selector_state.dart';

class RepUnitValueSelectorBloc extends Bloc<RepUnitValueSelectorEvent, RepUnitValueSelectorState> {
  RepUnitValueSelectorBloc({
    required double itemHeight,
  }) : super(RepUnitValueSelectorState(itemHeight: itemHeight));

  @override
  Stream<RepUnitValueSelectorState> mapEventToState(
    RepUnitValueSelectorEvent event,
  ) async* {
    if (event is RepUnitValueSelectorListScrollEnd) {
      yield* _mapScrollEndToState(event);
    } else if (event is RepUnitValueSelectorListScrollUpdated) {
      yield* _mapScrollUpdatedToState(event);
    } else if (event is RepUnitValueSelectorListSnapped) {
      yield state.copyWith(listState: RepUnitValueSelectorListState.dirty);
    }
  }

  Stream<RepUnitValueSelectorState> _mapScrollEndToState(RepUnitValueSelectorListScrollEnd event) async* {
    yield _calculateValues(event.scrollController, RepUnitValueSelectorListState.stop);
  }

  Stream<RepUnitValueSelectorState> _mapScrollUpdatedToState(RepUnitValueSelectorListScrollUpdated event) async* {
    yield _calculateValues(event.scrollController, RepUnitValueSelectorListState.scrolling);
  }

  RepUnitValueSelectorState _calculateValues(
    ScrollController controller,
    RepUnitValueSelectorListState listState,
  ) {
    final offset = controller.offset;

    final value = offset / state.itemHeight;

    final index = value.round();

    return state.copyWith(focusedValue: index, listState: listState);
  }
}

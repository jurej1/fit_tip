import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'draggable_value_selector_event.dart';
part 'draggable_value_selector_state.dart';

class DraggableValueSelectorBloc extends Bloc<DraggableValueSelectorEvent, DraggableValueSelectorState> {
  DraggableValueSelectorBloc() : super(DraggableValueSelectorState(focusedValue: 0, offset: 0));

  @override
  Stream<DraggableValueSelectorState> mapEventToState(
    DraggableValueSelectorEvent event,
  ) async* {
    if (event is DraggableValueSelectorScrollUpdate) {
      yield* _mapScrollUpdateToState(event);
    } else if (event is DraggableValueSelectorScrollEnd) {
      yield* _mapScrollEndToState(event);
    } else if (event is DraggableValueSelectorListSnapped) {
      yield state.copyWith(listState: DraggableValueSelectorListState.dirty);
    }
  }

  Stream<DraggableValueSelectorState> _mapScrollUpdateToState(DraggableValueSelectorScrollUpdate event) async* {
    yield _calculateValues(
      event.scrollController,
      event.itemHeight,
      DraggableValueSelectorListState.scrolling,
    );
  }

  Stream<DraggableValueSelectorState> _mapScrollEndToState(DraggableValueSelectorScrollEnd event) async* {
    yield _calculateValues(
      event.scrollController,
      event.itemHeight,
      DraggableValueSelectorListState.stop,
    );
  }

  DraggableValueSelectorState _calculateValues(ScrollController controller, double itemHeight, DraggableValueSelectorListState listState) {
    final offset = controller.offset;

    final value = offset / itemHeight;

    final focusedValue = value.round();

    return state.copyWith(
      focusedValue: focusedValue.isNegative ? 0 : focusedValue,
      offset: offset,
      listState: listState,
    );
  }
}

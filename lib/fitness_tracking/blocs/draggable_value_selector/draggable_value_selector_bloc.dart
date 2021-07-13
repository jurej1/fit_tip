import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:flutter/cupertino.dart';

part 'draggable_value_selector_event.dart';
part 'draggable_value_selector_state.dart';

class DraggableValueSelectorBloc extends Bloc<DraggableValueSelectorEvent, DraggableValueSelectorState> {
  DraggableValueSelectorBloc() : super(DraggableValueSelectorState());

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
    yield _calculateValues(event.scrollController, event.itemHeight);

    yield state.copyWith(listState: DraggableValueSelectorListState.scrolling);
  }

  Stream<DraggableValueSelectorState> _mapScrollEndToState(DraggableValueSelectorScrollEnd event) async* {
    yield _calculateValues(event.scrollController, event.itemHeight);

    yield state.copyWith(listState: DraggableValueSelectorListState.stop);
  }

  DraggableValueSelectorState _calculateValues(ScrollController controller, double itemHeight) {
    final offset = controller.offset;

    final value = offset / itemHeight;

    return state.copyWith(
      focusedValue: value.round(),
      offset: offset,
    );
  }
}

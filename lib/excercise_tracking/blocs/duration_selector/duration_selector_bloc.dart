import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'duration_selector_event.dart';
part 'duration_selector_state.dart';

class DurationSelectorBloc extends Bloc<DurationSelectorEvent, DurationSelectorState> {
  DurationSelectorBloc({
    int? duration,
  }) : super(
          duration != null
              ? DurationSelectorState(focusedIndex: DurationSelectorState.mapMinutesToIndex(duration))
              : DurationSelectorState(),
        );

  @override
  Stream<DurationSelectorState> mapEventToState(
    DurationSelectorEvent event,
  ) async* {
    yield* mapScrollToState(event);
    if (event is DurationSelectorScrollUpdated) {
      yield state.copyWith(status: DurationSelectorStatus.scrolling);
    } else if (event is DurationSelectorScrollEnd) {
      yield state.copyWith(status: DurationSelectorStatus.still);
    }
  }

  Stream<DurationSelectorState> mapScrollToState(DurationSelectorEvent event) async* {
    final ScrollController controller = event.controller;
    final double offset = controller.offset;

    final double index = offset / event.itemWidth;

    final focusedIndex = index.round();

    yield state.copyWith(
      focusedIndex: focusedIndex,
      offset: offset,
    );
  }
}

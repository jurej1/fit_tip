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
    if (event is DurationSelectorScrollUpdated) {
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
}

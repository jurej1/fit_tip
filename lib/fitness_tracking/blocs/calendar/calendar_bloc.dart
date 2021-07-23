import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/cupertino.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required Workout workout,
    required Size size,
  }) : super(
          CalendarState.pure(
            firstDay: workout.created,
            lastDay: workout.lastDay,
            size: size,
          ),
        );

  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
  ) async* {
    if (event is CalendarModeButtonPressed) {
      yield* _mapModeButtonPressedToState();
    }
  }

  Stream<CalendarState> _mapModeButtonPressedToState() async* {
    final int currentIndex = CalendarMode.values.indexOf(state.mode);

    if (currentIndex == CalendarMode.values.length - 1) {
      yield state.copyWith(mode: CalendarMode.values.elementAt(0));
    } else {
      yield state.copyWith(mode: CalendarMode.values.elementAt(currentIndex + 1));
    }
  }
}

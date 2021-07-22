import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required Workout workout,
  }) : super(
          CalendarState.pure(
            duration: workout.duration,
            firstDay: workout.created,
          ),
        );

  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
  ) async* {
    if (event is CalendarModeButtonPressed) {
      yield* _mapModeButtonPressedToState();
    } else if (event is CalendarPageChanged) {}
  }

  Stream<CalendarState> _mapModeButtonPressedToState() async* {
    final currentIndex = CalendarMode.values.indexOf(state.mode);

    if (currentIndex == CalendarMode.values.length - 1) {
      yield state.copyWith(mode: CalendarMode.values.elementAt(0));
    } else {
      yield state.copyWith(mode: CalendarMode.values.elementAt(currentIndex + 1));
    }
  }
}

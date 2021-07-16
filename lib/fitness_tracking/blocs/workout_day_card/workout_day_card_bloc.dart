import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_day_card_event.dart';
part 'workout_day_card_state.dart';

class WorkoutDayCardBloc extends Bloc<WorkoutDayCardEvent, WorkoutDayCardState> {
  WorkoutDayCardBloc({
    required WorkoutDay workoutDay,
  }) : super(WorkoutDayCardState(workoutDay: workoutDay));

  @override
  Stream<WorkoutDayCardState> mapEventToState(
    WorkoutDayCardEvent event,
  ) async* {
    if (event is WorkoutDayCardExpandedButtonPressed) {
      yield* _mapButtonPressedToState();
    }
  }

  Stream<WorkoutDayCardState> _mapButtonPressedToState() async* {
    yield state.copyWith(isExpanded: !state.isExpanded);
  }
}

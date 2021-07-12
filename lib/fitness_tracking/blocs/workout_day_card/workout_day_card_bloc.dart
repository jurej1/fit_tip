import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_day_card_event.dart';
part 'workout_day_card_state.dart';

class WorkoutDayCardBloc extends Bloc<WorkoutDayCardEvent, WorkoutDayCardState> {
  WorkoutDayCardBloc({
    required WorkoutDay workoutDay,
  }) : super(WorkoutDayCardState(workoutDay));

  @override
  Stream<WorkoutDayCardState> mapEventToState(
    WorkoutDayCardEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

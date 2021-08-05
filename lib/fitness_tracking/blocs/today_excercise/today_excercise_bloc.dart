import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'today_excercise_event.dart';
part 'today_excercise_state.dart';

class TodayExcerciseBloc extends Bloc<TodayExcerciseEvent, TodayExcerciseState> {
  TodayExcerciseBloc({
    required WorkoutDay workoutDay,
  }) : super(
          TodayExcerciseState(
            workoutDay: workoutDay,
            currentExcercise: workoutDay.excercises.first,
          ),
        );

  @override
  Stream<TodayExcerciseState> mapEventToState(
    TodayExcerciseEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

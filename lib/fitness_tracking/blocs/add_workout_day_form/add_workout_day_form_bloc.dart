import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/fitness_tracking/models/workout_muscle_group_list.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

part 'add_workout_day_form_event.dart';
part 'add_workout_day_form_state.dart';

class AddWorkoutDayFormBloc extends Bloc<AddWorkoutDayFormEvent, AddWorkoutDayFormState> {
  AddWorkoutDayFormBloc({
    required WorkoutDay workoutDay,
  }) : super(AddWorkoutDayFormState.initial(workoutDay));

  @override
  Stream<AddWorkoutDayFormState> mapEventToState(
    AddWorkoutDayFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

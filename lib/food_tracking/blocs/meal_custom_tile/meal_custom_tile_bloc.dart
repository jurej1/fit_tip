import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:food_repository/food_repository.dart';

part 'meal_custom_tile_event.dart';
part 'meal_custom_tile_state.dart';

class MealCustomTileBloc extends Bloc<MealCustomTileEvent, MealCustomTileState> {
  MealCustomTileBloc({
    Color textActiveColor = Colors.blue,
    Meal? meal,
    required CalorieDailyGoalBloc calorieDailyGoalBloc,
  }) : super(
          MealCustomTileState.initial(
            textActiveColor: textActiveColor,
            meal: meal,
            calorieDailyGoal: (calorieDailyGoalBloc.state is CalorieDailyGoalLoadSuccess)
                ? (calorieDailyGoalBloc.state as CalorieDailyGoalLoadSuccess).calorieDailyGoal
                : null,
          ),
        );

  @override
  Stream<MealCustomTileState> mapEventToState(
    MealCustomTileEvent event,
  ) async* {
    if (event is MealCustomTileExpandedPressed) {
      yield state.copyWith(isExpanded: !state.isExpanded);
    }
  }
}

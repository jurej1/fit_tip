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
    required MealType mealType,
    required CalorieDailyGoalBloc calorieDailyGoalBloc,
  })  : this._calorieDailyGoalBloc = calorieDailyGoalBloc,
        super(
          MealCustomTileState(
            meal: meal,
            mealType: mealType,
            mealCalorieGoal: (calorieDailyGoalBloc.state is CalorieDailyGoalLoadSuccess)
                ? MealCustomTileState.calorieMealGoal(
                    mealType,
                    (calorieDailyGoalBloc.state as CalorieDailyGoalLoadSuccess).calorieDailyGoal,
                  )
                : null,
          ),
        ) {
    _calorieDailyGoalSubscription = _calorieDailyGoalBloc.stream.listen((calState) {
      if (calState is CalorieDailyGoalLoadSuccess) {
        add(_MealCustomTileBlocUpdated((calState.calorieDailyGoal)));
      }
    });
  }

  late final StreamSubscription _calorieDailyGoalSubscription;
  final CalorieDailyGoalBloc _calorieDailyGoalBloc;

  @override
  Stream<MealCustomTileState> mapEventToState(
    MealCustomTileEvent event,
  ) async* {
    if (event is MealCustomTileExpandedPressed) {
      yield state.copyWith(isExpanded: !state.isExpanded);
    } else if (event is _MealCustomTileBlocUpdated) {
      yield state.copyWith(
        mealCalorieGoal: MealCustomTileState.calorieMealGoal(
          state.mealType,
          event.calorieDailyGoal,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _calorieDailyGoalSubscription.cancel();
    return super.close();
  }
}

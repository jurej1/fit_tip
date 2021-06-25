import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'meal_custom_tile_event.dart';
part 'meal_custom_tile_state.dart';

class MealCustomTileBloc extends Bloc<MealCustomTileEvent, MealCustomTileState> {
  MealCustomTileBloc({
    Color textActiveColor = Colors.blue,
  }) : super(MealCustomTileState(textActiveColor: textActiveColor));

  @override
  Stream<MealCustomTileState> mapEventToState(
    MealCustomTileEvent event,
  ) async* {
    if (event is MealCustomTileExpandedPressed) {
      yield state.copyWith(isExpanded: !state.isExpanded);
    }
  }
}

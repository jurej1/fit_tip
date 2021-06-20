import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'meal_custom_tile_event.dart';
part 'meal_custom_tile_state.dart';

class MealCustomTileBloc extends Bloc<MealCustomTileEvent, MealCustomTileState> {
  MealCustomTileBloc() : super(MealCustomTileState());

  @override
  Stream<MealCustomTileState> mapEventToState(
    MealCustomTileEvent event,
  ) async* {
    if (event is MealCustomTileExpandedPressed) {
      yield state.copyWith(isExpanded: !state.isExpanded);
    }
  }
}

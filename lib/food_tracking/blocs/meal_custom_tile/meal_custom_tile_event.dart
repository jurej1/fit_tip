part of 'meal_custom_tile_bloc.dart';

abstract class MealCustomTileEvent extends Equatable {
  const MealCustomTileEvent();

  @override
  List<Object> get props => [];
}

class _MealCustomTileBlocUpdated extends MealCustomTileEvent {
  final CalorieDailyGoal calorieDailyGoal;

  _MealCustomTileBlocUpdated(this.calorieDailyGoal);

  @override
  List<Object> get props => [calorieDailyGoal];
}

class MealCustomTileExpandedPressed extends MealCustomTileEvent {}

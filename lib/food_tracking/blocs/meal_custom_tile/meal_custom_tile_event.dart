part of 'meal_custom_tile_bloc.dart';

abstract class MealCustomTileEvent extends Equatable {
  const MealCustomTileEvent();

  @override
  List<Object> get props => [];
}

class MealCustomTileExpandedPressed extends MealCustomTileEvent {}

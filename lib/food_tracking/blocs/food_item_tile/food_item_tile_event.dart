part of 'food_item_tile_bloc.dart';

abstract class FoodItemTileEvent extends Equatable {
  const FoodItemTileEvent();

  @override
  List<Object> get props => [];
}

class FoodItemTileDeleteRequested extends FoodItemTileEvent {}

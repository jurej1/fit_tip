part of 'food_item_tile_bloc.dart';

abstract class FoodItemTileState extends Equatable {
  const FoodItemTileState(
    this.item,
  );

  final FoodItem item;

  @override
  List<Object> get props => [item];
}

class FoodItemTileInitial extends FoodItemTileState {
  FoodItemTileInitial(FoodItem item) : super(item);
}

class FoodItemTileLoading extends FoodItemTileState {
  FoodItemTileLoading(FoodItem item) : super(item);
}

class FoodItemTileDeletedSuccessfully extends FoodItemTileState {
  FoodItemTileDeletedSuccessfully(FoodItem item) : super(item);
}

class FoodItemTileDeleteFail extends FoodItemTileState {
  FoodItemTileDeleteFail(FoodItem item) : super(item);
}

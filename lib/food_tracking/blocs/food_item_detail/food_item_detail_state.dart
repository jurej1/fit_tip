part of 'food_item_detail_bloc.dart';

class FoodItemDetailState {
  const FoodItemDetailState(this.item);

  final FoodItem item;
}

class FoodItemDetailInitial extends FoodItemDetailState {
  FoodItemDetailInitial(FoodItem item) : super(item);
}

class FoodItemDetailLoading extends FoodItemDetailState {
  FoodItemDetailLoading(FoodItem item) : super(item);
}

class FoodItemDetailDeleteSuccess extends FoodItemDetailState {
  FoodItemDetailDeleteSuccess(FoodItem item) : super(item);
}

class FoodItemDetailDeleteFail extends FoodItemDetailState {
  FoodItemDetailDeleteFail(FoodItem item) : super(item);
}

part of 'food_item_detail_bloc.dart';

abstract class FoodItemDetailEvent extends Equatable {
  const FoodItemDetailEvent();

  @override
  List<Object?> get props => [];
}

class FoodItemDetailDeleteRequested extends FoodItemDetailEvent {}

class FoodItemDetailUpdated extends FoodItemDetailEvent {
  final FoodItem? foodItem;
  FoodItemDetailUpdated({this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

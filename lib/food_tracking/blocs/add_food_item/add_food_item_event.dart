part of 'add_food_item_bloc.dart';

abstract class AddFoodItemEvent extends Equatable {
  const AddFoodItemEvent();

  @override
  List<Object?> get props => [];
}

class AddFoodItemDateChanged extends AddFoodItemEvent {
  final DateTime? date;

  const AddFoodItemDateChanged({
    this.date,
  });
  @override
  List<Object?> get props => [date];
}

class AddFoodItemTimeConsumed extends AddFoodItemEvent {
  final TimeOfDay? timeOfDay;

  const AddFoodItemTimeConsumed({this.timeOfDay});
  @override
  List<Object?> get props => [timeOfDay];
}

class AddFoodItemNameChanged extends AddFoodItemEvent {
  final String? name;

  const AddFoodItemNameChanged({this.name});

  @override
  List<Object?> get props => [name];
}

class AddFoodItemAmountChanged extends AddFoodItemEvent {
  final String? value;

  const AddFoodItemAmountChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class AddFoodItemCalorieChanged extends AddFoodItemEvent {
  final String? value;

  const AddFoodItemCalorieChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class AddFoodItemMealTypeChanged extends AddFoodItemEvent {
  final MealType? value;

  const AddFoodItemMealTypeChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class AddFoodItemFatsChanged extends AddFoodItemEvent {
  final String? value;

  const AddFoodItemFatsChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class AddFoodItemCarbsChanged extends AddFoodItemEvent {
  final String? value;

  const AddFoodItemCarbsChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class AddFoodItemProteinChanged extends AddFoodItemEvent {
  final String? value;

  const AddFoodItemProteinChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class AddFooditemVitaminAdded extends AddFoodItemEvent {
  final FoodDataVitamin? vitamin;

  AddFooditemVitaminAdded({
    this.vitamin,
  });

  @override
  List<Object?> get props => [vitamin];
}

class AddFoodItemShowDetailPressed extends AddFoodItemEvent {}

class AddFoodItemSubmitForm extends AddFoodItemEvent {}

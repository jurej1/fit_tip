part of 'add_food_item_bloc.dart';

class AddFoodItemState extends Equatable {
  const AddFoodItemState({
    this.status = FormzStatus.pure,
    required this.dateConsumed,
    required this.timeConsumed,
    this.foodName = const FoodName.pure(),
    this.calorieConsumed = const CalorieConsumed.pure(),
    this.amountConsumed = const AmountConsumed.pure(),
    this.type = MealType.lunch,
    this.foodItem,
    this.fats = const AmountDetailConsumed.pure(),
    this.proteins = const AmountDetailConsumed.pure(),
    this.carbs = const AmountDetailConsumed.pure(),
    this.showDetail = false,
  });

  final FormzStatus status;
  final DateConsumed dateConsumed;
  final TimeConsumed timeConsumed;
  final FoodName foodName;
  final CalorieConsumed calorieConsumed;
  final AmountConsumed amountConsumed;
  final MealType type;
  final FoodItem? foodItem;
  final AmountDetailConsumed fats;
  final AmountDetailConsumed proteins;
  final AmountDetailConsumed carbs;
  final bool showDetail;

  factory AddFoodItemState.pure() {
    return AddFoodItemState(
      dateConsumed: DateConsumed.pure(),
      timeConsumed: TimeConsumed.pure(),
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      dateConsumed,
      timeConsumed,
      foodName,
      calorieConsumed,
      amountConsumed,
      type,
      foodItem,
      fats,
      proteins,
      carbs,
      showDetail,
    ];
  }

  AddFoodItemState copyWith({
    FormzStatus? status,
    DateConsumed? dateConsumed,
    TimeConsumed? timeConsumed,
    FoodName? foodName,
    CalorieConsumed? calorieConsumed,
    AmountConsumed? amountConsumed,
    MealType? type,
    FoodItem? foodItem,
    AmountDetailConsumed? fats,
    AmountDetailConsumed? proteins,
    AmountDetailConsumed? carbs,
    bool? showDetail,
  }) {
    return AddFoodItemState(
      status: status ?? this.status,
      dateConsumed: dateConsumed ?? this.dateConsumed,
      timeConsumed: timeConsumed ?? this.timeConsumed,
      foodName: foodName ?? this.foodName,
      calorieConsumed: calorieConsumed ?? this.calorieConsumed,
      amountConsumed: amountConsumed ?? this.amountConsumed,
      type: type ?? this.type,
      foodItem: foodItem ?? this.foodItem,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      showDetail: showDetail ?? this.showDetail,
    );
  }
}

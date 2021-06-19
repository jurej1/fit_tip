part of 'add_food_item_bloc.dart';

class AddFoodItemState extends Equatable {
  AddFoodItemState({
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
    this.vitamins = const [],
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
  final List<FoodDataVitamin> vitamins;

  factory AddFoodItemState.pure({FoodItem? item, DateTime? date}) {
    return AddFoodItemState(
      dateConsumed: item == null ? (date == null ? DateConsumed.pure() : DateConsumed.pure(date)) : DateConsumed.pure(item.dateAdded),
      timeConsumed: TimeConsumed.pure(),
      amountConsumed: item == null ? AmountConsumed.pure() : AmountConsumed.pure(item.amount.toString()),
      calorieConsumed: item == null ? CalorieConsumed.pure() : CalorieConsumed.pure(item.calories.toString()),
      carbs:
          item != null && item.macronutrients != null && item.macronutrients!.any((element) => element.macronutrient == Macronutrient.carbs)
              ? AmountDetailConsumed.pure(item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.carbs).amount.toString())
              : AmountDetailConsumed.pure(),
      fats: item != null && item.macronutrients != null && item.macronutrients!.any((element) => element.macronutrient == Macronutrient.fat)
          ? AmountDetailConsumed.pure(item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.fat).amount.toString())
          : AmountDetailConsumed.pure(),
      proteins: item != null &&
              item.macronutrients != null &&
              item.macronutrients!.any((element) => element.macronutrient == Macronutrient.protein)
          ? AmountDetailConsumed.pure(item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.protein).amount.toString())
          : AmountDetailConsumed.pure(),
      foodItem: item,
      foodName: item == null ? FoodName.pure() : FoodName.pure(item.name),
      type: item == null ? MealType.lunch : item.mealType,
      vitamins: item != null && item.vitamins != null ? item.vitamins! : [],
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
      vitamins,
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
    List<FoodDataVitamin>? vitamins,
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
      vitamins: vitamins ?? this.vitamins,
    );
  }
}

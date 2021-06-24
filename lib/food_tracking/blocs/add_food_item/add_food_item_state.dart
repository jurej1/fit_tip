part of 'add_food_item_bloc.dart';

enum AddFoodItemStateMode { edit, add }

class AddFoodItemState extends Equatable {
  AddFoodItemState({
    this.status = FormzStatus.pure,
    required this.dateConsumed,
    required this.timeConsumed,
    this.foodName = const FoodName.pure(),
    this.calorieConsumed = const CalorieConsumed.pure(),
    this.amountConsumed = const AmountConsumed.pure(),
    this.type = const MealTypeInputFormzModel.pure(),
    this.foodItem,
    this.fats = const AmountDetailConsumed.pure(),
    this.proteins = const AmountDetailConsumed.pure(),
    this.carbs = const AmountDetailConsumed.pure(),
    this.showDetail = false,
    this.vitamins = const VitaminsListModel.pure(),
    this.mode = AddFoodItemStateMode.add,
  });

  final FormzStatus status;
  final DateConsumed dateConsumed;
  final TimeConsumed timeConsumed;
  final FoodName foodName;
  final CalorieConsumed calorieConsumed;
  final AmountConsumed amountConsumed;
  final MealTypeInputFormzModel type;
  final FoodItem? foodItem;
  final AmountDetailConsumed fats;
  final AmountDetailConsumed proteins;
  final AmountDetailConsumed carbs;
  final bool showDetail;
  final VitaminsListModel vitamins;
  final AddFoodItemStateMode mode;

  factory AddFoodItemState.pure({DateTime? date}) {
    return AddFoodItemState(
      dateConsumed: date == null ? DateConsumed.pure() : DateConsumed.pure(date),
      mode: AddFoodItemStateMode.add,
      timeConsumed: TimeConsumed.pure(),
    );
  }

  factory AddFoodItemState.dirty({required FoodItem item}) {
    return AddFoodItemState(
      dateConsumed: DateConsumed.pure(item.dateAdded),
      timeConsumed: TimeConsumed.pure(TimeOfDay(hour: item.dateAdded.hour, minute: item.dateAdded.minute)),
      amountConsumed: AmountConsumed.pure(item.amount.toStringAsFixed(0)),
      calorieConsumed: CalorieConsumed.pure(item.calories.toStringAsFixed(0)),
      foodItem: item,
      foodName: FoodName.pure(item.name),
      mode: AddFoodItemStateMode.edit,
      showDetail: false,
      type: MealTypeInputFormzModel.pure(item.mealType),
      vitamins: VitaminsListModel.pure(item.vitamins ?? []),
      carbs: item.containsMacro(Macronutrient.carbs)
          ? AmountDetailConsumed.pure(item.getMacro(Macronutrient.carbs)!.amount.toStringAsFixed(0))
          : AmountDetailConsumed.pure(),
      fats: item.containsMacro(Macronutrient.fat)
          ? AmountDetailConsumed.dirty(item.getMacro(Macronutrient.fat)!.amount.toStringAsFixed(0))
          : AmountDetailConsumed.pure(),
      proteins: item.containsMacro(Macronutrient.protein)
          ? AmountDetailConsumed.dirty(item.getMacro(Macronutrient.protein)!.amount.toStringAsFixed(0))
          : AmountDetailConsumed.pure(),
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
      mode,
    ];
  }

  AddFoodItemState copyWith({
    FormzStatus? status,
    DateConsumed? dateConsumed,
    TimeConsumed? timeConsumed,
    FoodName? foodName,
    CalorieConsumed? calorieConsumed,
    AmountConsumed? amountConsumed,
    MealTypeInputFormzModel? type,
    FoodItem? foodItem,
    AmountDetailConsumed? fats,
    AmountDetailConsumed? proteins,
    AmountDetailConsumed? carbs,
    bool? showDetail,
    VitaminsListModel? vitamins,
    AddFoodItemStateMode? mode,
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
      mode: mode ?? this.mode,
    );
  }
}

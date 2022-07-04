part of 'meal_custom_tile_bloc.dart';

class MealCustomTileState extends Equatable {
  const MealCustomTileState({
    this.isExpanded = false,
    this.textActiveColor = Colors.blue,
    this.meal,
    this.mealCalorieGoal,
    required this.mealType,
  });

  final bool isExpanded;
  final Color textActiveColor;
  final Meal? meal;
  final int? mealCalorieGoal;
  final MealType mealType;

  bool hasFoods() {
    return meal?.foods.isNotEmpty ?? false;
  }

  List<FoodItem> get foods => meal?.foods ?? [];

  @override
  List<Object?> get props {
    return [
      isExpanded,
      textActiveColor,
      meal,
      mealCalorieGoal,
      mealType,
    ];
  }

  factory MealCustomTileState.initial({
    Meal? meal,
    Color? textActiveColor,
    CalorieDailyGoal? calorieDailyGoal,
    required MealType mealType,
  }) {
    return MealCustomTileState(
      meal: meal,
      textActiveColor: textActiveColor ?? Colors.blue,
      mealCalorieGoal: MealCustomTileState.calorieMealGoal(mealType, calorieDailyGoal),
      mealType: mealType,
    );
  }

  static int? calorieMealGoal(MealType type, CalorieDailyGoal? calorieDailyGoal) {
    if (type == MealType.breakfast) {
      return calorieDailyGoal?.breakfast;
    } else if (type == MealType.lunch) {
      return calorieDailyGoal?.lunch;
    } else if (type == MealType.dinner) {
      return calorieDailyGoal?.dinner;
    } else if (type == MealType.snack) {
      return calorieDailyGoal?.snack;
    } else {
      return null;
    }
  }

  MealCustomTileState copyWith({
    bool? isExpanded,
    Color? textActiveColor,
    Meal? meal,
    int? mealCalorieGoal,
    MealType? mealType,
  }) {
    return MealCustomTileState(
      isExpanded: isExpanded ?? this.isExpanded,
      textActiveColor: textActiveColor ?? this.textActiveColor,
      meal: meal ?? this.meal,
      mealCalorieGoal: mealCalorieGoal ?? this.mealCalorieGoal,
      mealType: mealType ?? this.mealType,
    );
  }
}

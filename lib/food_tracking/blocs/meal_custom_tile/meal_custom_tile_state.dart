part of 'meal_custom_tile_bloc.dart';

class MealCustomTileState extends Equatable {
  const MealCustomTileState({
    this.isExpanded = false,
    this.textActiveColor = Colors.blue,
    this.meal,
    this.mealCalorieGoal,
  });

  final bool isExpanded;
  final Color textActiveColor;
  final Meal? meal;
  final int? mealCalorieGoal;

  bool hasFoods() {
    return meal?.foods.isNotEmpty ?? false;
  }

  List<FoodItem> get foods => meal?.foods ?? [];

  @override
  List<Object?> get props => [isExpanded, textActiveColor, meal, mealCalorieGoal];

  factory MealCustomTileState.initial({
    Meal? meal,
    Color? textActiveColor,
    CalorieDailyGoal? calorieDailyGoal,
  }) {
    return MealCustomTileState(
      meal: meal,
      textActiveColor: textActiveColor ?? Colors.blue,
      mealCalorieGoal: _calorieMealGoal(meal?.type, calorieDailyGoal),
    );
  }

  static int? _calorieMealGoal(MealType? type, CalorieDailyGoal? calorieDailyGoal) {
    if (calorieDailyGoal == null || type == null) return null;

    if (type == MealType.breakfast) {
      return calorieDailyGoal.breakfast;
    } else if (type == MealType.lunch) {
      return calorieDailyGoal.lunch;
    } else if (type == MealType.dinner) {
      return calorieDailyGoal.dinner;
    } else if (type == MealType.snack) {
      return calorieDailyGoal.snack;
    }
  }

  MealCustomTileState copyWith({
    bool? isExpanded,
    Color? textActiveColor,
    Meal? meal,
    int? mealCalorieGoal,
  }) {
    return MealCustomTileState(
      isExpanded: isExpanded ?? this.isExpanded,
      textActiveColor: textActiveColor ?? this.textActiveColor,
      meal: meal ?? this.meal,
      mealCalorieGoal: mealCalorieGoal ?? this.mealCalorieGoal,
    );
  }
}

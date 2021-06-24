import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

class MealDay extends Equatable {
  final Meal? snacks;
  final Meal? dinner;
  final Meal? lunch;
  final Meal? breakfast;
  final int totalCalories;

  MealDay({
    this.snacks,
    this.dinner,
    this.lunch,
    this.breakfast,
    int? totalCalories,
  }) : this.totalCalories = totalCalories ??
            List<FoodItem>.from(
              (snacks != null ? snacks.foods : []) +
                  (dinner != null ? dinner.foods : []) +
                  (lunch != null ? lunch.foods : []) +
                  (breakfast != null ? breakfast.foods : []),
            ).fold(
              0,
              (p, e) => p + e.calories.toInt(),
            );

  @override
  List<Object?> get props => [snacks, dinner, lunch, breakfast];

  int getMacroAmount(Macronutrient macro) {
    final items = List<FoodItem>.from(
      (snacks != null ? snacks!.foods : []) +
          (dinner != null ? dinner!.foods : []) +
          (lunch != null ? lunch!.foods : []) +
          (breakfast != null ? breakfast!.foods : []),
    );

    return items.fold(0, (previousValue, element) {
      if (element.containsMacro(macro)) {
        return element.getMacro(macro)!.amount.toInt() + previousValue;
      }
      return previousValue;
    });
  }

  MealDay copyWith({
    Meal? snacks,
    Meal? dinner,
    Meal? lunch,
    Meal? breakfast,
  }) {
    return MealDay(
      snacks: snacks ?? this.snacks,
      dinner: dinner ?? this.dinner,
      lunch: lunch ?? this.lunch,
      breakfast: breakfast ?? this.breakfast,
    );
  }
}

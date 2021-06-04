import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

class MealDay extends Equatable {
  final Meal? snacks;
  final Meal? dinner;
  final Meal? lunch;
  final Meal? breakfast;
  final double totalCalories;

  MealDay({
    this.snacks,
    this.dinner,
    this.lunch,
    this.breakfast,
    double? totalCalories,
  }) : this.totalCalories = totalCalories ??
            List<FoodItem>.from(
              (snacks != null ? snacks.foods : []) +
                  (dinner != null ? dinner.foods : []) +
                  (lunch != null ? lunch.foods : []) +
                  (breakfast != null ? breakfast.foods : []),
            ).fold(
              0.0,
              (p, e) => p + e.amount,
            );

  @override
  List<Object?> get props => [snacks, dinner, lunch, breakfast];

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

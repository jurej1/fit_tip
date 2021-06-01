import 'package:equatable/equatable.dart';
import 'package:food_repository/src/enums/enums.dart';

import 'models.dart';

class Meal extends Equatable {
  final List<FoodItem> foods;
  final double totalCalories;
  final MealType type;

  Meal({
    required this.foods,
    double? totalCalories,
    required this.type,
  }) : this.totalCalories = totalCalories ?? foods.fold(0.0, (p, e) => p + e.calories);

  @override
  List<Object> get props => [foods, totalCalories, type];

  Meal copyWith({
    List<FoodItem>? foods,
    double? totalCalories,
    MealType? type,
  }) {
    return Meal(
      foods: foods ?? this.foods,
      totalCalories: totalCalories ?? this.totalCalories,
      type: type ?? this.type,
    );
  }
}

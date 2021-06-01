import 'package:equatable/equatable.dart';
import 'package:food_repository/src/enums/enums.dart';

import 'models.dart';

class Meal extends Equatable {
  final List<FoodItem> foods;
  final double totalCalories;
  final MealType type;
  final DateTime date;

  Meal({
    double? totalCalories,
    List<FoodItem> foods = const [],
    required this.type,
    required this.date,
  })   : this.foods = foods..sort((a, b) => b.dateAdded.compareTo(a.dateAdded)),
        this.totalCalories = totalCalories ?? foods.fold(0.0, (p, e) => p + e.calories);

  @override
  List<Object> get props => [foods, totalCalories, type];

  Meal copyWith({
    List<FoodItem>? foods,
    double? totalCalories,
    MealType? type,
    DateTime? date,
  }) {
    return Meal(
      foods: foods ?? this.foods,
      totalCalories: totalCalories ?? this.totalCalories,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}

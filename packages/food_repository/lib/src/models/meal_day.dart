import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

class MealDay extends Equatable {
  final Meal? snacks;
  final Meal? dinner;
  final Meal? lunch;
  final Meal? breakfast;

  MealDay({
    this.snacks,
    this.dinner,
    this.lunch,
    this.breakfast,
  });

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

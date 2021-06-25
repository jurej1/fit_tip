import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/calorie_daily_goal_entity.dart';

class CalorieDailyGoal extends Equatable {
  final int amount;
  final int? fats;
  final int? proteins;
  final int? carbs;
  final int? breakfast;
  final int? lunch;
  final int? dinner;
  final int? snack;
  final DateTime date;
  final String id;

  CalorieDailyGoal({
    String? id,
    this.amount = 0,
    this.fats,
    this.proteins,
    this.carbs,
    this.breakfast,
    this.dinner,
    this.lunch,
    this.snack,
    DateTime? date,
  })  : this.date = date ?? DateTime.now(),
        this.id = id ?? generateId(date ?? DateTime.now());

  @override
  List<Object?> get props {
    return [
      amount,
      fats,
      proteins,
      carbs,
      breakfast,
      lunch,
      dinner,
      snack,
      date,
      id,
    ];
  }

  CalorieDailyGoal copyWith({
    int? amount,
    int? fats,
    int? proteins,
    int? carbs,
    int? breakfast,
    int? lunch,
    int? dinner,
    int? snack,
    DateTime? date,
    String? id,
  }) {
    return CalorieDailyGoal(
      amount: amount ?? this.amount,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snack: snack ?? this.snack,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  static String generateId(DateTime date) {
    return CalorieDailyGoalEntity.generateId(date);
  }

  CalorieDailyGoalEntity toEntity() {
    return CalorieDailyGoalEntity(
      date: date,
      amount: amount,
      id: id,
      carbs: carbs,
      fats: fats,
      proteins: proteins,
      breakfast: breakfast,
      dinner: dinner,
      lunch: lunch,
      snack: snack,
    );
  }

  static CalorieDailyGoal fromEntity(CalorieDailyGoalEntity entity) {
    return CalorieDailyGoal(
      amount: entity.amount,
      date: entity.date,
      carbs: entity.carbs,
      fats: entity.fats,
      id: entity.id,
      proteins: entity.proteins,
      breakfast: entity.breakfast,
      dinner: entity.dinner,
      lunch: entity.lunch,
      snack: entity.snack,
    );
  }
}

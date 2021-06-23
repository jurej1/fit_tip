import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/calorie_daily_goal_entity.dart';

class CalorieDailyGoal extends Equatable {
  final double amount;
  final int? fats;
  final int? proteins;
  final int? carbs;
  final DateTime date;
  final String id;

  CalorieDailyGoal({
    String? id,
    this.amount = 0,
    this.fats,
    this.proteins,
    this.carbs,
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
      date,
      id,
    ];
  }

  CalorieDailyGoal copyWith({
    double? amount,
    int? fats,
    int? proteins,
    int? carbs,
    DateTime? date,
    String? id,
  }) {
    return CalorieDailyGoal(
      amount: amount ?? this.amount,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
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
    );
  }
}

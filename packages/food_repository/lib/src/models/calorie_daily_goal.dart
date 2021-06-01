import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/calorie_daily_goal_entity.dart';

class CalorieDailyGoal extends Equatable {
  final double amount;
  final DateTime date;
  final String id;

  CalorieDailyGoal({
    required this.amount,
    required this.date,
    String? id,
  }) : this.id = id ?? generateId(date);

  @override
  List<Object> get props => [amount, date, id];

  CalorieDailyGoal copyWith({
    double? amount,
    DateTime? date,
    String? id,
  }) {
    return CalorieDailyGoal(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  static String generateId(DateTime date) {
    return CalorieDailyGoalEntity.generateId(date);
  }

  CalorieDailyGoalEntity toEntity() {
    return CalorieDailyGoalEntity(date: date, amount: amount, id: id);
  }

  static CalorieDailyGoal fromEntity(CalorieDailyGoalEntity entity) {
    return CalorieDailyGoal(amount: entity.amount, date: entity.date);
  }
}

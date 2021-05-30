import 'package:equatable/equatable.dart';
import 'package:water_repository/entity/entity.dart';

class WaterDailyGoal extends Equatable {
  final double amount;
  final String id;
  final DateTime date;

  const WaterDailyGoal({
    required this.amount,
    required this.id,
    required this.date,
  });

  @override
  List<Object> get props => [amount, id, date];

  static WaterDailyGoal fromEntity(WaterGoalDailyEntity entity) {
    return WaterDailyGoal(
      date: entity.date,
      id: entity.id,
      amount: entity.amount,
    );
  }

  WaterGoalDailyEntity toEntity() {
    return WaterGoalDailyEntity(
      amount: this.amount,
      date: this.date,
      id: this.id,
    );
  }

  static generateId(DateTime date) {
    return WaterGoalDailyEntity.generateId(date);
  }

  WaterDailyGoal copyWith({
    double? amount,
    String? id,
    DateTime? date,
  }) {
    return WaterDailyGoal(
      amount: amount ?? this.amount,
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:water_repository/entity/entity.dart';

class WaterGoalDaily extends Equatable {
  final double amount;
  final String id;
  final DateTime date;

  const WaterGoalDaily({
    required this.amount,
    required this.id,
    required this.date,
  });

  @override
  List<Object> get props => [amount];

  static WaterGoalDaily fromEntity(WaterGoalDailyEntity entity) {
    return WaterGoalDaily(
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

  WaterGoalDaily copyWith({
    double? amount,
    String? id,
    DateTime? date,
  }) {
    return WaterGoalDaily(
      amount: amount ?? this.amount,
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:water_repository/entity/entity.dart';

class WaterGoalDaily extends Equatable {
  final double dailyGoal;

  const WaterGoalDaily({
    required this.dailyGoal,
  });

  @override
  List<Object> get props => [dailyGoal];

  static WaterGoalDaily fromEntity(WaterGoalDailyEntity entity) {
    return WaterGoalDaily(dailyGoal: entity.dailyGoal);
  }

  WaterGoalDailyEntity toEntity() {
    return WaterGoalDailyEntity(dailyGoal: this.dailyGoal);
  }
}

import 'package:equatable/equatable.dart';
import 'package:water_repository/entity/entity.dart';
import 'package:water_repository/models/water_daily_aditional_info.dart';

class WaterDailyInfo extends Equatable {
  final DateTime date;
  final double amount;
  final List<WaterDailyAditionalInfo> info;

  WaterDailyInfo({
    required this.date,
    required this.amount,
    required this.info,
  });

  @override
  List<Object> get props => [date, amount, info];

  WaterDailyInfo copyWith({
    DateTime? date,
    double? amount,
    List<WaterDailyAditionalInfo>? info,
  }) {
    return WaterDailyInfo(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      info: info ?? this.info,
    );
  }

  static WaterDailyInfo fromEntity(WaterDailyInfoEntity entity) {
    return WaterDailyInfo(
      date: entity.date,
      amount: entity.amount,
      info: entity.info.map((e) => WaterDailyAditionalInfo.fromEntity(e)).toList(),
    );
  }
}

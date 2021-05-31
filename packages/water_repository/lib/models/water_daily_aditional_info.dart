import 'package:equatable/equatable.dart';
import 'package:water_repository/entity/water_daily_aditional_info_entity.dart';

class WaterDailyAditionalInfo extends Equatable {
  final String info;
  final double amount;

  const WaterDailyAditionalInfo({
    required this.info,
    required this.amount,
  });

  @override
  List<Object> get props => [info, amount];

  WaterDailyAditionalInfo copyWith({
    String? info,
    double? amount,
  }) {
    return WaterDailyAditionalInfo(
      info: info ?? this.info,
      amount: amount ?? this.amount,
    );
  }

  WaterDailyAditionalInfoEntity toEntity() {
    return WaterDailyAditionalInfoEntity(info: this.info, amount: this.amount);
  }

  static WaterDailyAditionalInfo fromEntity(WaterDailyAditionalInfoEntity entity) {
    return WaterDailyAditionalInfo(info: entity.info, amount: entity.amount);
  }
}

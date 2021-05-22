import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'water_daily_aditional_info_entity.dart';

class WaterDailyInfoEntity extends Equatable {
  final DateTime date;
  final double amount;
  final List<WaterDailyAditionalInfoEntity> info;

  WaterDailyInfoEntity({
    required this.date,
    required this.amount,
    required this.info,
  });

  @override
  List<Object> get props => [date, amount, info];

  static WaterDailyInfoEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map;

    final info = data['info'] as List;

    final date = data['date'] as Timestamp;

    return WaterDailyInfoEntity(
      date: date.toDate(),
      amount: data['amount'],
      info: info.map((e) {
        return WaterDailyAditionalInfoEntity.fromDocumentSnapshot(e);
      }).toList(),
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'info': info.map((e) => e.toDocumentSnapshot()).toList(),
      'date': Timestamp.fromDate(date),
      'amount': amount,
    };
  }
}

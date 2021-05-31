import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WaterDailyAditionalInfoEntity extends Equatable {
  final String info;
  final double amount;

  const WaterDailyAditionalInfoEntity({
    required this.info,
    required this.amount,
  });
  @override
  List<Object> get props => [info, amount];

  WaterDailyAditionalInfoEntity copyWith({
    String? info,
    double? amount,
  }) {
    return WaterDailyAditionalInfoEntity(
      info: info ?? this.info,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'info': info,
      'amount': amount,
    };
  }

  static WaterDailyAditionalInfoEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map;
    return WaterDailyAditionalInfoEntity(
      info: data['info'],
      amount: data['amount'],
    );
  }
}

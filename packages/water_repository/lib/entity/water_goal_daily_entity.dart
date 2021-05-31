import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WaterGoalDailyEntity extends Equatable {
  final double amount;
  final String id;
  final DateTime date;

  const WaterGoalDailyEntity({
    required this.amount,
    required this.id,
    required this.date,
  });

  @override
  List<Object> get props => [amount, id, date];

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }

  static WaterGoalDailyEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map;

    return WaterGoalDailyEntity(
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      id: snap.id,
    );
  }

  WaterGoalDailyEntity copyWith({
    double? amount,
    String? id,
    DateTime? date,
  }) {
    return WaterGoalDailyEntity(
      amount: amount ?? this.amount,
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }

  static String generateId(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}

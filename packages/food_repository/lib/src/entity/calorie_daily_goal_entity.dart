import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CalorieDailyGoalEntity extends Equatable {
  final double amount;
  final DateTime date;
  final String id;

  CalorieDailyGoalEntity({
    this.amount = 2000,
    required this.date,
    String? id,
  }) : this.id = id ?? generateId(date);

  @override
  List<Object> get props => [amount, date, id];

  CalorieDailyGoalEntity copyWith({
    double? amount,
    DateTime? date,
    String? id,
  }) {
    return CalorieDailyGoalEntity(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(
        DateTime(date.year, date.month, date.day),
      )
    };
  }

  static String generateId(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  static CalorieDailyGoalEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    final DateTime date = (data['date'] as Timestamp).toDate();

    return CalorieDailyGoalEntity(
      date: date,
      amount: data['amount'],
    );
  }
}

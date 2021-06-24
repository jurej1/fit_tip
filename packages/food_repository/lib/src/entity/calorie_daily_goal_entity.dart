import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static String amount = 'amount';
  static String date = 'date';
  static String fats = 'fats';
  static String proteins = 'proteins';
  static String carbs = 'carbs';
}

class CalorieDailyGoalEntity extends Equatable {
  final int amount;
  final DateTime date;
  final int? fats;
  final int? proteins;
  final int? carbs;
  final String id;

  CalorieDailyGoalEntity({
    String? id,
    this.amount = 2000,
    DateTime? date,
    this.fats,
    this.proteins,
    this.carbs,
  })  : this.date = date ?? DateTime.now(),
        this.id = id ?? generateId(date ?? DateTime.now());

  @override
  List<Object?> get props {
    return [
      amount,
      date,
      fats,
      proteins,
      carbs,
      id,
    ];
  }

  CalorieDailyGoalEntity copyWith({
    int? amount,
    DateTime? date,
    int? fats,
    int? proteins,
    int? carbs,
    String? id,
  }) {
    return CalorieDailyGoalEntity(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.amount: amount,
      _DocKeys.date: Timestamp.fromDate(
        DateTime(date.year, date.month, date.day),
      ),
      if (this.carbs != null) _DocKeys.carbs: this.carbs,
      if (this.proteins != null) _DocKeys.proteins: this.proteins,
      if (this.fats != null) _DocKeys.fats: this.fats,
    };
  }

  static String generateId(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  static CalorieDailyGoalEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    final DateTime date = (data[_DocKeys.date] as Timestamp).toDate();

    return CalorieDailyGoalEntity(
      date: date,
      amount: data[_DocKeys.amount],
      carbs: data[_DocKeys.carbs],
      fats: data[_DocKeys.fats],
      id: snap.id,
      proteins: data[_DocKeys.proteins],
    );
  }
}

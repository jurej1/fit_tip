import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static String amount = 'amount';
  static String date = 'date';
  static String fats = 'fats';
  static String proteins = 'proteins';
  static String carbs = 'carbs';
  static String breakfast = 'breakfast';
  static String lunch = 'lunch';
  static String dinner = 'dinner';
  static String snack = 'snack';
}

class CalorieDailyGoalEntity extends Equatable {
  final int amount;
  final DateTime date;
  final int? fats;
  final int? proteins;
  final int? carbs;
  final int? breakfast;
  final int? lunch;
  final int? dinner;
  final int? snack;
  final String id;

  CalorieDailyGoalEntity({
    String? id,
    DateTime? date,
    this.amount = 2000,
    this.fats,
    this.proteins,
    this.carbs,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
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
      breakfast,
      lunch,
      dinner,
      snack,
      id,
    ];
  }

  CalorieDailyGoalEntity copyWith({
    int? amount,
    DateTime? date,
    int? fats,
    int? proteins,
    int? carbs,
    int? breakfast,
    int? lunch,
    int? dinner,
    int? snack,
    String? id,
  }) {
    return CalorieDailyGoalEntity(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snack: snack ?? this.snack,
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
      if (this.dinner != null) _DocKeys.dinner: this.dinner,
      if (this.snack != null) _DocKeys.snack: this.snack,
      if (this.lunch != null) _DocKeys.lunch: this.lunch,
      if (this.breakfast != null) _DocKeys.breakfast: this.breakfast,
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
      proteins: data[_DocKeys.proteins],
      breakfast: data[_DocKeys.breakfast],
      dinner: data[_DocKeys.dinner],
      lunch: data[_DocKeys.lunch],
      snack: data[_DocKeys.snack],
    );
  }
}

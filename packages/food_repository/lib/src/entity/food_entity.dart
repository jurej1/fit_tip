import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String id;
  final String name;
  final DocumentReference sourceRef;
  final double amount;
  final double calories;
  final DateTime dateAdded;

  const FoodEntity({
    required this.id,
    required this.name,
    required this.sourceRef,
    required this.amount,
    required this.calories,
    required this.dateAdded,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      sourceRef,
      amount,
      calories,
      dateAdded,
    ];
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'name': name,
      'sourceRef': sourceRef,
      'amount': amount,
      'calories': calories,
      'dateAdded': Timestamp.fromDate(dateAdded),
    };
  }

  static FoodEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return FoodEntity(
      amount: data['amount'],
      calories: data['calories'],
      dateAdded: (data['dateAdded'] as Timestamp).toDate(),
      id: snap.id,
      name: data['name'],
      sourceRef: data['sourceRef'],
    );
  }

  FoodEntity copyWith({
    String? id,
    String? name,
    DocumentReference? sourceRef,
    double? amount,
    double? calories,
    DateTime? dateAdded,
  }) {
    return FoodEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceRef: sourceRef ?? this.sourceRef,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/entity.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final DocumentReference sourceRef;
  final double amount;
  final double calories;
  final DateTime dateAdded;

  Food({
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

  Food copyWith({
    String? id,
    String? name,
    DocumentReference? sourceRef,
    double? amount,
    double? calories,
    DateTime? dateAdded,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceRef: sourceRef ?? this.sourceRef,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  FoodEntity toEntity() {
    return FoodEntity(
      amount: this.amount,
      calories: this.calories,
      dateAdded: this.dateAdded,
      id: this.id,
      name: this.name,
      sourceRef: this.sourceRef,
    );
  }

  static Food fromEntity(FoodEntity entity) {
    return Food(
      amount: entity.amount,
      calories: entity.calories,
      dateAdded: entity.dateAdded,
      id: entity.id,
      name: entity.name,
      sourceRef: entity.sourceRef,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/entity.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final DocumentReference sourceRef;
  final double amount;
  final double calories;
  final DateTime dateAdded;

  FoodItem({
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

  FoodItem copyWith({
    String? id,
    String? name,
    DocumentReference? sourceRef,
    double? amount,
    double? calories,
    DateTime? dateAdded,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceRef: sourceRef ?? this.sourceRef,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  FoodItemEntity toEntity() {
    return FoodItemEntity(
      amount: this.amount,
      calories: this.calories,
      dateAdded: this.dateAdded,
      id: this.id,
      name: this.name,
      sourceRef: this.sourceRef,
    );
  }

  static FoodItem fromEntity(FoodItemEntity entity) {
    return FoodItem(
      amount: entity.amount,
      calories: entity.calories,
      dateAdded: entity.dateAdded,
      id: entity.id,
      name: entity.name,
      sourceRef: entity.sourceRef,
    );
  }
}

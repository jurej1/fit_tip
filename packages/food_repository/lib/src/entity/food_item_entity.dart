import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:food_repository/src/entity/entity.dart';
import 'package:food_repository/src/enums/enums.dart';

class FoodItemEntity extends Equatable {
  final String? id;
  final String name;
  final DocumentReference? sourceRef;
  final double amount;
  final double calories;
  final DateTime dateAdded;
  final MealType mealType;
  final List<FoodDataMacroEntity>? macronutrients;
  final List<FoodDataVitaminEntity>? vitamins;

  const FoodItemEntity({
    this.id,
    required this.name,
    this.sourceRef,
    required this.amount,
    required this.calories,
    required this.dateAdded,
    required this.mealType,
    this.macronutrients,
    this.vitamins,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      sourceRef,
      amount,
      calories,
      dateAdded,
      mealType,
      macronutrients,
      vitamins,
    ];
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'name': name,
      'sourceRef': sourceRef,
      'amount': amount,
      'calories': calories,
      'dateAdded': Timestamp.fromDate(dateAdded),
      'mealType': describeEnum(mealType),
      if (macronutrients != null) 'macronutrients': macronutrients!.map((e) => e.toDocumentSnapshot(e)).toList(),
      if (vitamins != null) 'vitamins': vitamins!.map((e) => e.toDocumentSnapshot(e)).toList()
    };
  }

  static FoodItemEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return FoodItemEntity(
        amount: data['amount'],
        calories: data['calories'],
        dateAdded: (data['dateAdded'] as Timestamp).toDate(),
        id: snap.id,
        name: data['name'],
        sourceRef: data['sourceRef'],
        mealType: MealType.values.firstWhere((e) => describeEnum(e) == data['mealType']),
        macronutrients: data.containsKey('macronutrients')
            ? (data['macronutrients'] as List<dynamic>).map((e) => FoodDataEntity.fromDocumentSnapshot(e)).toList()
                as List<FoodDataMacroEntity>
            : null,
        vitamins: data.containsKey('vitamins')
            ? (data['vitamins'] as List<dynamic>).map((e) => FoodDataEntity.fromDocumentSnapshot(e)).toList() as List<FoodDataVitaminEntity>
            : null);
  }

  FoodItemEntity copyWith({
    String? id,
    String? name,
    DocumentReference? sourceRef,
    double? amount,
    double? calories,
    DateTime? dateAdded,
    MealType? mealType,
    List<FoodDataMacroEntity>? macronutrients,
    List<FoodDataVitaminEntity>? vitamins,
  }) {
    return FoodItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceRef: sourceRef ?? this.sourceRef,
      amount: amount ?? this.amount,
      calories: calories ?? this.calories,
      dateAdded: dateAdded ?? this.dateAdded,
      mealType: mealType ?? this.mealType,
      macronutrients: macronutrients ?? this.macronutrients,
      vitamins: vitamins ?? this.vitamins,
    );
  }
}

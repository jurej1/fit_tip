import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:food_repository/src/entity/entity.dart';
import 'package:food_repository/src/enums/enums.dart';

class _DocKeys {
  static String name = 'name';
  static String sourceRef = 'sourceRef';
  static String amount = 'amount';
  static String calories = 'calories';
  static String dateAdded = 'dateAdded';
  static String mealType = 'mealType';
  static String macronutrients = 'macronutrients';
  static String vitamins = 'vitamins';
}

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
      _DocKeys.name: name,
      _DocKeys.sourceRef: sourceRef,
      _DocKeys.amount: amount,
      _DocKeys.calories: calories,
      _DocKeys.dateAdded: Timestamp.fromDate(dateAdded),
      _DocKeys.mealType: describeEnum(mealType),
      if (macronutrients != null) _DocKeys.macronutrients: macronutrients!.map((e) => e.toDocumentSnapshot()).toList(),
      if (vitamins != null) _DocKeys.vitamins: vitamins!.map((e) => e.toDocumentSnapshot()).toList()
    };
  }

  static FoodItemEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return FoodItemEntity(
      amount: data[_DocKeys.amount],
      calories: data[_DocKeys.calories],
      dateAdded: (data[_DocKeys.dateAdded] as Timestamp).toDate(),
      id: snap.id,
      name: data[_DocKeys.name],
      sourceRef: data[_DocKeys.sourceRef],
      mealType: MealType.values.firstWhere((e) => describeEnum(e) == data[_DocKeys.mealType]),
      macronutrients: data.containsKey(_DocKeys.macronutrients)
          ? (data[_DocKeys.macronutrients] as List<dynamic>).map((e) => FoodDataMacroEntity.fromMap(e)).toList()
          : null,
      vitamins: data.containsKey(_DocKeys.vitamins)
          ? (data[_DocKeys.vitamins] as List<dynamic>).map((e) => FoodDataVitaminEntity.fromMap(e)).toList()
          : null,
    );
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

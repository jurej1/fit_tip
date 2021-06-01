import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:food_repository/src/entity/entity.dart';
import 'package:food_repository/src/enums/enums.dart';

class FoodEntity extends Equatable {
  final String id;
  final String name;
  final double calories;
  final List<FoodDataEntity> macronutrients;
  final List<FoodDataEntity> minerals;
  final List<FoodDataEntity> vitamins;
  final List<FoodDataEntity> madeOf;
  final FoodGroup group;
  final DocumentReference ref;

  FoodEntity({
    required this.id,
    required this.name,
    required this.calories,
    required this.macronutrients,
    required this.minerals,
    required this.vitamins,
    required this.madeOf,
    required this.group,
    required this.ref,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      calories,
      macronutrients,
      minerals,
      vitamins,
      madeOf,
      group,
      ref,
    ];
  }

  FoodEntity copyWith({
    String? id,
    String? name,
    double? calories,
    List<FoodDataEntity>? macronutrients,
    List<FoodDataEntity>? minerals,
    List<FoodDataEntity>? vitamins,
    List<FoodDataEntity>? madeOf,
    FoodGroup? group,
    DocumentReference? ref,
  }) {
    return FoodEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      macronutrients: macronutrients ?? this.macronutrients,
      minerals: minerals ?? this.minerals,
      vitamins: vitamins ?? this.vitamins,
      madeOf: madeOf ?? this.madeOf,
      group: group ?? this.group,
      ref: ref ?? this.ref,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'name': name,
      'calories': calories,
      'macronutrients': macronutrients,
      'minerals': minerals.map((e) => e.toDocumentSnapshot()).toList(),
      'vitamins': vitamins.map((e) => e.toDocumentSnapshot()).toList(),
      'madeOf': madeOf.map((e) => e.toDocumentSnapshot()).toList(),
      'group': describeEnum(group),
    };
  }

  static FoodEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return FoodEntity(
      calories: data['calories'],
      group: FoodGroup.values.firstWhere((element) => describeEnum(element) == data['group']),
      id: snap.id,
      ref: snap.reference,
      macronutrients: (data['macronutrients'] as List<dynamic>).map((e) => FoodDataEntity.fromDocumentSnapshot(e)).toList(),
      madeOf: (data['madeOf'] as List<dynamic>).map((e) => FoodDataEntity.fromDocumentSnapshot(e)).toList(),
      minerals: (data['minerals'] as List<dynamic>).map((e) => FoodDataEntity.fromDocumentSnapshot(e)).toList(),
      name: data['name'],
      vitamins: (data['vitamines'] as List<dynamic>).map((e) => FoodDataEntity.fromDocumentSnapshot(e)).toList(),
    );
  }
}

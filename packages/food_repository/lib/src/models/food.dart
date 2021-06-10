import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/entity.dart';
import 'package:food_repository/src/enums/enums.dart';

import 'food_data.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final double calories;
  final List<FoodDataMacro> macronutrients;
  final List<FoodDataMineral> minerals;
  final List<FoodDataVitamin> vitamins;
  final List<FoodDataMadeOf> madeOf;
  final FoodGroup group;
  final DocumentReference ref;

  Food({
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

  Food copyWith({
    String? id,
    String? name,
    double? calories,
    List<FoodDataMacro>? macronutrients,
    List<FoodDataMineral>? minerals,
    List<FoodDataVitamin>? vitamins,
    List<FoodDataMadeOf>? madeOf,
    FoodGroup? group,
    DocumentReference? ref,
  }) {
    return Food(
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

  FoodEntity toEntity() {
    return FoodEntity(
      id: id,
      name: name,
      calories: calories,
      macronutrients: macronutrients.map((e) => e.toEntity()).toList(),
      minerals: minerals.map((e) => e.toEntity()).toList(),
      vitamins: vitamins.map((e) => e.toEntity()).toList(),
      madeOf: madeOf.map((e) => e.toEntity()).toList(),
      group: group,
      ref: ref,
    );
  }

  static Food fromEntity(FoodEntity entity) {
    return Food(
      calories: entity.calories,
      group: entity.group,
      id: entity.id,
      macronutrients: entity.macronutrients.map((e) => FoodDataMacro.fromEntity(e)).toList(),
      madeOf: entity.madeOf.map((e) => FoodDataMadeOf.fromEntity(e)).toList(),
      minerals: entity.minerals.map((e) => FoodDataMineral.fromEntity(e)).toList(),
      name: entity.name,
      ref: entity.ref,
      vitamins: entity.vitamins.map((e) => FoodDataVitamin.fromEntity(e)).toList(),
    );
  }
}

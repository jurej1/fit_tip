import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../food_repository.dart';

abstract class FoodDataEntity extends Equatable {
  final double? amount;

  const FoodDataEntity({
    this.amount,
  });

  @override
  List<Object?> get props => [amount];

  Map<String, dynamic> toDocumentSnapshot(Object name) {
    return {
      'amount': amount,
      'name': describeEnum(name),
    };
  }

  static FoodDataEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final amount = data['amount'];

    bool isMacro = Macronutrient.values.any((element) => name == describeEnum(element));

    if (isMacro) {
      return FoodDataMacroEntity(
        macronutrient: Macronutrient.values.firstWhere((e) => describeEnum(e) == name),
        amount: amount,
      );
    }

    bool isMineral = Mineral.values.any((element) => name == describeEnum(element));
    if (isMineral) {
      return FoodDataMineralEntity(
        mineral: Mineral.values.firstWhere((e) => describeEnum(e) == name),
        amount: amount,
      );
    }

    bool isVitamin = Vitamin.values.any((element) => name == describeEnum(element));
    if (isVitamin) {
      return FoodDataVitaminEntity(
        vitamin: Vitamin.values.firstWhere((e) => describeEnum(e) == name),
        amount: amount,
      );
    }

    return FoodDataMadeOfEntity(
      madeOf: MadeOf.values.firstWhere((e) => describeEnum(e) == name),
      amount: amount,
    );
  }
}

class FoodDataMacroEntity extends FoodDataEntity {
  final Macronutrient macronutrient;

  const FoodDataMacroEntity({
    required this.macronutrient,
    double? amount,
  }) : super(amount: amount);

  @override
  List<Object?> get props => [macronutrient, amount];

  FoodDataMacro copyWith({
    Macronutrient? macronutrient,
    double? amount,
  }) {
    return FoodDataMacro(
      macronutrient: macronutrient ?? this.macronutrient,
      amount: amount ?? this.amount,
    );
  }
}

class FoodDataMineralEntity extends FoodDataEntity {
  final Mineral mineral;

  const FoodDataMineralEntity({
    double? amount,
    required this.mineral,
  }) : super(amount: amount);

  @override
  List<Object?> get props => [mineral, amount];

  FoodDataMineral copyWith({
    Mineral? mineral,
    double? amount,
  }) {
    return FoodDataMineral(
      mineral: mineral ?? this.mineral,
      amount: amount ?? this.amount,
    );
  }
}

class FoodDataVitaminEntity extends FoodDataEntity {
  final Vitamin vitamin;
  const FoodDataVitaminEntity({
    double? amount,
    required this.vitamin,
  }) : super(amount: amount);

  @override
  List<Object?> get props => [vitamin, amount];

  FoodDataVitamin copyWith({
    Vitamin? vitamin,
    double? amount,
  }) {
    return FoodDataVitamin(
      amount: amount ?? this.amount,
      vitamin: vitamin ?? this.vitamin,
    );
  }
}

class FoodDataMadeOfEntity extends FoodDataEntity {
  final MadeOf madeOf;

  const FoodDataMadeOfEntity({
    required this.madeOf,
    double? amount,
  }) : super(amount: amount);

  @override
  List<Object?> get props => [madeOf, amount];

  FoodDataMadeOf copyWith({
    MadeOf? madeOf,
    double? amount,
  }) {
    return FoodDataMadeOf(
      madeOf: madeOf ?? this.madeOf,
      amount: amount ?? this.amount,
    );
  }
}

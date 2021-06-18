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
}

class FoodDataMacroEntity extends FoodDataEntity {
  final Macronutrient macronutrient;

  const FoodDataMacroEntity({
    required this.macronutrient,
    double? amount,
  }) : super(amount: amount);

  @override
  List<Object?> get props => [macronutrient, amount];

  static FoodDataMacroEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final amount = data['amount'];

    return FoodDataMacroEntity(
      macronutrient: Macronutrient.values.firstWhere((e) => describeEnum(e) == name),
      amount: amount,
    );
  }

  static FoodDataMacroEntity fromMap(Map<dynamic, dynamic> map) {
    return FoodDataMacroEntity(
      macronutrient: Macronutrient.values.firstWhere((e) => describeEnum(e) == map['name']),
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'name': describeEnum(macronutrient),
    };
  }

  FoodDataMacroEntity copyWith({Macronutrient? macronutrient, double? amount}) {
    return FoodDataMacroEntity(
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

  FoodDataMineralEntity copyWith({
    Mineral? mineral,
    double? amount,
  }) {
    return FoodDataMineralEntity(
      mineral: mineral ?? this.mineral,
      amount: amount ?? this.amount,
    );
  }

  static FoodDataMineralEntity fromMap(Map<dynamic, dynamic> map) {
    return FoodDataMineralEntity(
      mineral: Mineral.values.firstWhere((e) => describeEnum(e) == map['name']),
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'name': describeEnum(mineral),
    };
  }

  static FoodDataMineralEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final amount = data['amount'];

    return FoodDataMineralEntity(
      mineral: Mineral.values.firstWhere((e) => describeEnum(e) == name),
      amount: amount,
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

  static FoodDataVitaminEntity fromMap(Map<dynamic, dynamic> map) {
    return FoodDataVitaminEntity(
      vitamin: Vitamin.values.firstWhere((e) => describeEnum(e) == map['name']),
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'name': describeEnum(vitamin),
    };
  }

  static FoodDataVitaminEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final amount = data['amount'];

    return FoodDataVitaminEntity(
      vitamin: Vitamin.values.firstWhere((e) => describeEnum(e) == name),
      amount: amount,
    );
  }

  FoodDataVitaminEntity copyWith({
    Vitamin? vitamin,
  }) {
    return FoodDataVitaminEntity(
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

  FoodDataMadeOfEntity copyWith({
    MadeOf? madeOf,
    double? amount,
  }) {
    return FoodDataMadeOfEntity(
      madeOf: madeOf ?? this.madeOf,
      amount: amount ?? this.amount,
    );
  }

  static FoodDataMadeOfEntity fromMap(Map<dynamic, dynamic> map) {
    return FoodDataMadeOfEntity(
      madeOf: MadeOf.values.firstWhere((e) => describeEnum(e) == map['name']),
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'amount': amount,
      'name': describeEnum(madeOf),
    };
  }

  static FoodDataMadeOfEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final amount = data['amount'];

    return FoodDataMadeOfEntity(
      madeOf: MadeOf.values.firstWhere((e) => describeEnum(e) == name),
      amount: amount,
    );
  }
}

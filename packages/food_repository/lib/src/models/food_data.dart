import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';
import 'package:food_repository/src/entity/entity.dart';

abstract class FoodData extends Equatable {
  final double amount;

  const FoodData({
    double? amount,
  }) : this.amount = amount ?? 0.0;

  @override
  List<Object?> get props => [amount];
}

class FoodDataMacro extends FoodData {
  final Macronutrient macronutrient;

  const FoodDataMacro({
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

class FoodDataMineral extends FoodData {
  final Mineral mineral;

  const FoodDataMineral({
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

class FoodDataVitamin extends FoodData {
  final Vitamin vitamin;
  const FoodDataVitamin({
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

class FoodDataMadeOf extends FoodData {
  final MadeOf madeOf;

  const FoodDataMadeOf({
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

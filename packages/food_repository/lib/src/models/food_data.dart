import 'package:equatable/equatable.dart';
import 'package:food_repository/src/entity/entity.dart';

class FoodData extends Equatable {
  final double? amount;
  final String name;

  const FoodData({
    this.amount,
    required this.name,
  });

  @override
  List<Object?> get props => [amount, name];

  FoodData copyWith({
    double? amount,
    String? name,
  }) {
    return FoodData(
      amount: amount ?? this.amount,
      name: name ?? this.name,
    );
  }

  FoodDataEntity toEntity() {
    return FoodDataEntity(
      name: name,
      amount: amount,
    );
  }

  static FoodData fromEntity(FoodDataEntity entity) {
    return FoodData(
      name: entity.name,
      amount: entity.amount,
    );
  }
}

import 'package:equatable/equatable.dart';

import '../entity/water_cup_entity.dart';
import '../enums/enums.dart';

class WaterCup extends Equatable {
  final DrinkingCupSize size;
  final double amount;
  final String? imagePath;

  const WaterCup({
    required this.size,
    required this.amount,
    this.imagePath,
  });

  @override
  List<Object?> get props => [size, amount, imagePath];

  WaterCup copyWith({
    DrinkingCupSize? size,
    double? amount,
    String? imagePath,
  }) {
    return WaterCup(
      size: size ?? this.size,
      amount: amount ?? this.amount,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  WaterCupEntity toEntity() {
    return WaterCupEntity(
      size: this.size,
      amount: this.amount,
      imagePath: this.imagePath,
    );
  }

  factory WaterCup.fromEntity(WaterCupEntity entity) {
    return WaterCup(
      amount: entity.amount,
      imagePath: entity.imagePath,
      size: entity.size,
    );
  }
}

class WaterCups {
  static const values = [
    tee,
    small,
    large,
    pintUK,
    pintUS,
    wine,
    extraLarge,
    medium,
    coffe,
  ];

  static const tee = WaterCup(
    amount: 150,
    size: DrinkingCupSize.tee,
  );

  static const small = WaterCup(
    amount: 250,
    size: DrinkingCupSize.small,
  );

  static const large = WaterCup(
    amount: 750,
    size: DrinkingCupSize.large,
  );
  static const pintUK = WaterCup(
    amount: 570,
    size: DrinkingCupSize.pintUK,
  );

  static const pintUS = WaterCup(
    amount: 470,
    size: DrinkingCupSize.pintUS,
  );

  static const wine = WaterCup(
    amount: 240,
    size: DrinkingCupSize.wine,
  );

  static const extraLarge = WaterCup(
    amount: 1000,
    size: DrinkingCupSize.extraLarge,
  );

  static const medium = WaterCup(
    amount: 500,
    size: DrinkingCupSize.medium,
  );

  static const coffe = WaterCup(
    amount: 200,
    size: DrinkingCupSize.coffee,
  );
}

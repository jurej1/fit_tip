import 'package:equatable/equatable.dart';

import '../enums/enums.dart';

class WaterCup extends Equatable {
  final DrinkingCupSize size;
  final double amount;
  final String imagePath;
  const WaterCup({
    required this.size,
    required this.amount,
    required this.imagePath,
  });

  @override
  List<Object> get props => [size, amount, imagePath];

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
}

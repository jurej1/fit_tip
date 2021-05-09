import 'package:bmi_calculator/bmi_repository.dart';
import 'package:equatable/equatable.dart';

class BMIResult extends Equatable {
  final WeightCategory category;
  final double value;

  const BMIResult({
    required this.category,
    required this.value,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

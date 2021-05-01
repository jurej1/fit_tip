import 'package:equatable/equatable.dart';
import '../entity/entity.dart';

class WeightActive extends Equatable {
  final num? weight;

  const WeightActive({
    this.weight,
  });

  @override
  List<Object?> get props => [weight];

  WeightActive copyWith({
    num? weight,
  }) {
    return WeightActive(
      weight: weight ?? this.weight,
    );
  }

  WeightActiveEntity toEntity() {
    return WeightActiveEntity(current: weight);
  }

  WeightActive fromEntity(WeightActiveEntity entity) {
    return WeightActive(weight: entity.current);
  }
}

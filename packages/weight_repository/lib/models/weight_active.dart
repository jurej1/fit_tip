import 'package:equatable/equatable.dart';
import '../entity/entity.dart';

class Weight extends Equatable {
  final num? weight;
  final DateTime? dateAdded;

  const Weight({
    this.weight,
    this.dateAdded,
  });

  @override
  List<Object?> get props => [weight];

  Weight copyWith({
    num? weight,
  }) {
    return Weight(
      weight: weight ?? this.weight,
    );
  }

  WeightEntity toEntity() {
    return WeightEntity(current: weight);
  }

  static Weight fromEntity(WeightEntity entity) {
    return Weight(weight: entity.current);
  }
}

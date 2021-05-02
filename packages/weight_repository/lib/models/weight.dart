import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../entity/entity.dart';

class Weight extends Equatable {
  final String? id;
  final num? weight;
  final DateTime? date;

  const Weight({
    this.weight,
    this.id,
    this.date,
  });

  @override
  List<Object?> get props => [weight, date, id];

  Weight copyWith({
    String? id,
    num? weight,
    DateTime? date,
  }) {
    return Weight(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      date: date ?? this.date,
    );
  }

  WeightEntity toEntity() {
    return WeightEntity(
      weight: weight,
      date: date != null ? Timestamp.fromDate(date!) : null,
      id: id,
    );
  }

  static Weight fromEntity(WeightEntity entity) {
    return Weight(
      weight: entity.weight,
      date: entity.date?.toDate(),
      id: entity.id,
    );
  }
}

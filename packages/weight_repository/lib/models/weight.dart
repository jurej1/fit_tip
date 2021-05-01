import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../entity/entity.dart';

class Weight extends Equatable {
  final String? id;
  final num? weight;
  final DateTime? dateAdded;

  const Weight({
    this.weight,
    this.id,
    this.dateAdded,
  });

  @override
  List<Object?> get props => [weight, dateAdded, id];

  Weight copyWith({
    String? id,
    num? weight,
    DateTime? dateAdded,
  }) {
    return Weight(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  WeightEntity toEntity() {
    return WeightEntity(
      current: weight,
      dateAdded: dateAdded != null ? Timestamp.fromDate(dateAdded!) : null,
      id: id,
    );
  }

  static Weight fromEntity(WeightEntity entity) {
    return Weight(
      weight: entity.current,
      dateAdded: entity.dateAdded?.toDate(),
      id: entity.id,
    );
  }
}

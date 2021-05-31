import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DocKeysWeight {
  static get weight => 'weight';
  static get date => 'date';
}

class WeightEntity extends Equatable {
  final num? weight;
  final String? id;
  final Timestamp? date;

  const WeightEntity({
    this.weight,
    this.date,
    this.id,
  });

  @override
  List<Object?> get props => [weight, date, id];

  WeightEntity copyWith({
    num? weight,
    String? id,
    Timestamp? date,
  }) {
    return WeightEntity(
      weight: weight ?? this.weight,
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      if (weight != null) DocKeysWeight.weight: weight,
      if (date != null) DocKeysWeight.date: date,
    };
  }

  static WeightEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final Map<String, dynamic> doc = snap.data() as Map<String, dynamic>;

    return WeightEntity(
      id: snap.id,
      weight: doc[DocKeysWeight.weight],
      date: doc[DocKeysWeight.date],
    );
  }
}

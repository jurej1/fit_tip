import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static get current => 'current';
}

class WeightActiveEntity extends Equatable {
  final num? current;

  const WeightActiveEntity({this.current});

  @override
  List<Object?> get props => [current];

  WeightActiveEntity copyWith({
    num? current,
  }) {
    return WeightActiveEntity(
      current: current ?? this.current,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      if (current != null) _DocKeys.current: current,
    };
  }

  WeightActiveEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    return WeightActiveEntity(
      current: snap.data()?[_DocKeys.current],
    );
  }
}

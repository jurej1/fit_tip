import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static get current => 'current';
  static get dateAdded => 'dateAdded';
}

class WeightEntity extends Equatable {
  final num? current;
  final String? id;
  final Timestamp? dateAdded;

  const WeightEntity({
    this.current,
    this.dateAdded,
    this.id,
  });

  @override
  List<Object?> get props => [current, dateAdded, id];

  WeightEntity copyWith({
    num? current,
    String? id,
    Timestamp? dateAdded,
  }) {
    return WeightEntity(
      current: current ?? this.current,
      id: id ?? this.id,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      if (current != null) _DocKeys.current: current,
      if (dateAdded != null) _DocKeys.dateAdded: dateAdded,
    };
  }

  static WeightEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final doc = snap.data()!;

    return WeightEntity(
      id: snap.id,
      current: doc[_DocKeys.current],
      dateAdded: doc[_DocKeys.dateAdded],
    );
  }
}

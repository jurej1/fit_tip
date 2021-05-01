import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static get current => 'current';
  static get dateAdded => 'dateAdded';
}

class WeightEntity extends Equatable {
  final num? current;
  final Timestamp? dateAdded;

  const WeightEntity({this.current, this.dateAdded});

  @override
  List<Object?> get props => [current, dateAdded];

  WeightEntity copyWith({
    num? current,
    Timestamp? dateAdded,
  }) {
    return WeightEntity(
      current: current ?? this.current,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      if (current != null) _DocKeys.current: current,
      if (dateAdded != null) _DocKeys.dateAdded: dateAdded,
    };
  }

  static WeightEntity? fromDocumentSnapshot(DocumentSnapshot snap) {
    final doc = snap.data();

    if (doc == null) return null;

    return WeightEntity(
      current: doc[_DocKeys.current],
      dateAdded: doc[_DocKeys.dateAdded],
    );
  }
}

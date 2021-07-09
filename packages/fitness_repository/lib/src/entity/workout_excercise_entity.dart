import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/foundation.dart';

class _DocKeys {
  static String name = 'name';
  static String sets = 'sets';
  static String reps = 'reps';
  static String repUnit = 'unit';
}

class WorkoutExcerciseEntity extends Equatable {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final RepUnit repUnit;

  const WorkoutExcerciseEntity({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.repUnit,
  });
  @override
  List<Object> get props {
    return [
      id,
      name,
      sets,
      reps,
      repUnit,
    ];
  }

  WorkoutExcerciseEntity copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    RepUnit? unit,
  }) {
    return WorkoutExcerciseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      repUnit: unit ?? this.repUnit,
    );
  }

  static WorkoutExcerciseEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WorkoutExcerciseEntity(
      id: snapshot.id,
      name: data[_DocKeys.name],
      sets: data[_DocKeys.sets],
      reps: data[_DocKeys.reps],
      repUnit: RepUnit.values.firstWhere(
        (element) => describeEnum(element) == data[_DocKeys.repUnit],
      ),
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.name: this.name,
      _DocKeys.reps: this.reps,
      _DocKeys.sets: this.reps,
      _DocKeys.repUnit: describeEnum(this.repUnit),
    };
  }
}

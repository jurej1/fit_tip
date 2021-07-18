import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class _DocKeys {
  static String name = 'name';
  static String sets = 'sets';
  static String reps = 'reps';
  static String repUnit = 'unit';
  static String id = 'id';
}

class WorkoutExcerciseEntity extends Equatable {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final RepUnit repUnit;

  WorkoutExcerciseEntity({
    String? id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.repUnit,
  }) : this.id = id ?? UniqueKey().toString();

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

  Map<String, dynamic> toMap() {
    return {
      _DocKeys.id: this.id,
      _DocKeys.name: this.name,
      _DocKeys.reps: this.reps,
      _DocKeys.sets: this.reps,
      _DocKeys.repUnit: describeEnum(this.repUnit),
    };
  }

  static WorkoutExcerciseEntity fromMap(Map<String, dynamic> map) {
    return WorkoutExcerciseEntity(
      id: map[_DocKeys.id],
      name: map[_DocKeys.name],
      sets: map[_DocKeys.sets],
      reps: map[_DocKeys.reps],
      repUnit: RepUnit.values.firstWhere((element) => describeEnum(element) == map[_DocKeys.repUnit]),
    );
  }
}

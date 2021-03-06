import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _DocKeys {
  static String name = 'name';
  static String sets = 'sets';
  static String reps = 'reps';
  static String repUnit = 'unit';
  static String id = 'id';
  static String repCount = 'repCount';
  static String weightCount = 'weightCount';
}

class WorkoutExcerciseEntity extends Equatable {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final RepUnit repUnit;
  final List<int>? repCount;
  final List<double>? weightCount;

  WorkoutExcerciseEntity({
    this.weightCount,
    String? id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.repUnit,
    this.repCount,
  }) : this.id = id ?? UniqueKey().toString();

  @override
  List<Object?> get props {
    return [
      id,
      name,
      sets,
      reps,
      repUnit,
      repCount,
      weightCount,
    ];
  }

  WorkoutExcerciseEntity copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    RepUnit? repUnit,
    List<int>? repCount,
    List<double>? weightCount,
  }) {
    return WorkoutExcerciseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      repUnit: repUnit ?? this.repUnit,
      repCount: repCount ?? this.repCount,
      weightCount: weightCount ?? this.weightCount,
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
      _DocKeys.sets: this.sets,
      _DocKeys.repUnit: describeEnum(this.repUnit),
      if (this.repCount != null) _DocKeys.repCount: this.repCount,
      if (this.weightCount != null) _DocKeys.weightCount: this.weightCount,
    };
  }

  Map<String, dynamic> toMapLog() {
    return {
      _DocKeys.id: this.id,
      _DocKeys.name: this.name,
      _DocKeys.repUnit: describeEnum(this.repUnit),
      _DocKeys.repCount: this.repCount,
      _DocKeys.weightCount: this.weightCount,
    };
  }

  static WorkoutExcerciseEntity fromMap(Map<String, dynamic> map) {
    List<int>? repCount = map.containsKey(_DocKeys.repCount)
        ? (map[_DocKeys.repCount] as List<dynamic>)
            .map(
              (e) => e as int,
            )
            .toList()
        : null;
    List<double>? weightCount = map.containsKey(_DocKeys.weightCount)
        ? (map[_DocKeys.weightCount] as List<dynamic>)
            .map(
              (e) => e as double,
            )
            .toList()
        : null;
    return WorkoutExcerciseEntity(
      id: map[_DocKeys.id],
      name: map[_DocKeys.name],
      sets: map.containsKey(_DocKeys.sets) ? map[_DocKeys.sets] : repCount?.length ?? 0,
      reps: map.containsKey(_DocKeys.reps) ? map[_DocKeys.reps] : repCount?.first ?? 0,
      repUnit: RepUnit.values.firstWhere((element) => describeEnum(element) == map[_DocKeys.repUnit]),
      repCount: repCount,
      weightCount: weightCount,
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/foundation.dart';

import '../../fitness_repository.dart';

class _DocKeys {
  static String note = 'note';
  static String day = 'day';
  static String musclesTargeted = 'musclesTargeted';
  static String excercises = 'excercises';
  static String id = 'id';
}

class WorkoutDayEntity extends Equatable {
  final String id;
  final String? note;
  final int day;
  final List<MuscleGroup>? musclesTargeted;
  final List<WorkoutExcerciseEntity> excercises;

  const WorkoutDayEntity({
    required this.id,
    this.note,
    required this.day,
    this.musclesTargeted,
    this.excercises = const [],
  });

  int get numberOfExcercises => excercises.length;

  @override
  List<Object?> get props {
    return [
      id,
      note,
      day,
      musclesTargeted,
      excercises,
    ];
  }

  WorkoutDayEntity copyWith({
    String? id,
    String? note,
    int? day,
    List<MuscleGroup>? musclesTargeted,
    List<WorkoutExcerciseEntity>? excercises,
  }) {
    return WorkoutDayEntity(
      id: id ?? this.id,
      note: note ?? this.note,
      day: day ?? this.day,
      musclesTargeted: musclesTargeted ?? this.musclesTargeted,
      excercises: excercises ?? this.excercises,
    );
  }

  static WorkoutDayEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return WorkoutDayEntity(
      id: snap.id,
      day: data[_DocKeys.day],
      note: data[_DocKeys.note],
      musclesTargeted: (data[_DocKeys.musclesTargeted] as List<String>)
          .map(
            (e) => MuscleGroup.values.firstWhere(
              (element) => describeEnum(element) == e,
            ),
          )
          .toList(),
    );
  }

  static WorkoutDayEntity fromMap(Map<String, dynamic> map) {
    return WorkoutDayEntity(
      id: map[_DocKeys.id],
      day: map[_DocKeys.day],
      musclesTargeted: (map[_DocKeys.musclesTargeted] as List<String>).map((e) {
        return MuscleGroup.values.firstWhere((element) => describeEnum(element) == e);
      }).toList(),
      excercises: (map[_DocKeys.excercises] as List<Map<String, dynamic>>).map((e) => WorkoutExcerciseEntity.fromMap(e)).toList(),
      note: map[_DocKeys.note],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.id: this.id,
      _DocKeys.day: this.day,
      if (this.musclesTargeted != null) _DocKeys.musclesTargeted: this.musclesTargeted?.map((e) => describeEnum(e)).toList(),
      if (this.note != null) _DocKeys.note: this.note,
      _DocKeys.excercises: this.excercises.map((e) => e.toMap()).toList(),
    };
  }
}

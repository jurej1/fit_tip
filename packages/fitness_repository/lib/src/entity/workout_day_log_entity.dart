import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:flutter/foundation.dart';

import '../../fitness_repository.dart';

class _DocKeys {
  static String workoutId = 'workoutId';
  static String workoutDayId = 'workoutDayId';
  static String muscleTargeted = 'musclesTargeted';
  static String excercises = 'excercises';
  static String created = 'created';
  static String duration = 'duration';
}

class WorkoutDayLogEntity extends Equatable {
  final String id;
  final String workoutId;
  final String workoutDayId;
  final List<MuscleGroup>? musclesTargeted;
  final List<WorkoutExcerciseEntity> excercises;
  final DateTime created;
  final Duration duration;

  const WorkoutDayLogEntity({
    required this.id,
    required this.workoutId,
    required this.workoutDayId,
    required this.excercises,
    required this.created,
    this.musclesTargeted,
    this.duration = Duration.zero,
  });

  @override
  List<Object?> get props {
    return [
      id,
      workoutId,
      workoutDayId,
      musclesTargeted,
      excercises,
      created,
      duration,
    ];
  }

  WorkoutDayLogEntity copyWith({
    String? id,
    String? workoutId,
    String? workoutDayId,
    List<MuscleGroup>? musclesTargeted,
    List<WorkoutExcerciseEntity>? excercises,
    DateTime? created,
    Duration? duration,
  }) {
    return WorkoutDayLogEntity(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      musclesTargeted: musclesTargeted ?? this.musclesTargeted,
      excercises: excercises ?? this.excercises,
      created: created ?? this.created,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.created: Timestamp.fromDate(created),
      _DocKeys.excercises: excercises.map((e) => e.toMap()).toList(),
      if (musclesTargeted != null) _DocKeys.muscleTargeted: musclesTargeted!.map((e) => describeEnum(e)).toList(),
      _DocKeys.workoutDayId: workoutDayId,
      _DocKeys.workoutId: workoutId,
      _DocKeys.duration: duration.inMilliseconds,
    };
  }

  static WorkoutDayLogEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    final Timestamp created = data[_DocKeys.created] as Timestamp;

    final List<dynamic> excercises = data[_DocKeys.excercises] as List<dynamic>;

    return WorkoutDayLogEntity(
      id: snap.id,
      workoutId: data[_DocKeys.workoutId],
      workoutDayId: data[_DocKeys.workoutDayId],
      excercises: excercises
          .map<WorkoutExcerciseEntity>(
            (e) => WorkoutExcerciseEntity.fromMap(e),
          )
          .toList(),
      created: created.toDate(),
      musclesTargeted: data.containsKey(_DocKeys.muscleTargeted)
          ? ((data[_DocKeys.muscleTargeted] as List<dynamic>)
              .map<MuscleGroup>(
                (e) => MuscleGroup.values.firstWhere((element) => describeEnum(element) == e),
              )
              .toList())
          : null,
      duration: data.containsKey(_DocKeys.duration) ? Duration(milliseconds: data[_DocKeys.duration]) : Duration.zero,
    );
  }
}

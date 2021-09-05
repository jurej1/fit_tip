import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../fitness_repository.dart';
import 'workout_excercise_entity.dart';

class WorkoutDayRawDocKeys {
  static String workoutId = 'workoutId';
  static String note = 'note';
  static String muscles = 'muscles';
  static String excercises = 'excercises';
  static String id = 'id';
}

class WorkoutDayDocKeys {
  static String weekday = 'weekday';
}

class WorkoutDayLogDocKeys {
  static String userId = 'userId';
  static String created = 'created';
  static String duration = 'duration';
}

abstract class WorkoutDayRawEntity extends Equatable {
  final String id;
  final String workoutId;
  final String? note;

  final List<MuscleGroup>? muscles;
  final List<WorkoutExcerciseEntity>? excercises;

  WorkoutDayRawEntity({
    String? id,
    required this.workoutId,
    this.note,
    this.muscles,
    this.excercises,
  }) : this.id = id ?? UniqueKey().toString();

  @override
  List<Object?> get props {
    return [
      id,
      workoutId,
      note,
      muscles,
      excercises,
    ];
  }

  int get numberOfMusclesTargeted => this.muscles?.length ?? 0;
  int get numberOfExcercises => this.excercises?.length ?? 0;
}

class WorkoutDayEntity extends WorkoutDayRawEntity {
  final int weekday;
  WorkoutDayEntity({
    int? weekday,
    String? id,
    required String workoutId,
    String? note,
    List<MuscleGroup>? muscles,
    List<WorkoutExcerciseEntity>? excercises,
  })  : weekday = weekday ?? 0,
        super(
          id: id,
          workoutId: workoutId,
          excercises: excercises,
          muscles: muscles,
          note: note,
        );

  @override
  List<Object?> get props {
    return [weekday];
  }

  WorkoutDayEntity copyWith({
    String? id,
    String? workoutId,
    String? note,
    int? weekday,
    List<MuscleGroup>? muscles,
    List<WorkoutExcerciseEntity>? excercises,
  }) {
    return WorkoutDayEntity(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      note: note ?? this.note,
      weekday: weekday ?? this.weekday,
      muscles: muscles ?? this.muscles,
      excercises: excercises ?? this.excercises,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      WorkoutDayDocKeys.weekday: this.weekday,
      if (this.excercises != null) WorkoutDayRawDocKeys.excercises: this.excercises!.map((e) => e.toMap()).toList(),
      if (this.muscles != null) WorkoutDayRawDocKeys.muscles: this.muscles!.map((e) => describeEnum(e)).toList(),
      if (this.note != null) WorkoutDayRawDocKeys.note: this.note,
      WorkoutDayRawDocKeys.id: this.id,
    };
  }

  static WorkoutDayEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return WorkoutDayEntity(
      workoutId: '',
      id: data[WorkoutDayRawDocKeys.id],
      note: data.containsKey(WorkoutDayRawDocKeys.note) ? data[WorkoutDayRawDocKeys.note] : null,
      weekday: data[WorkoutDayDocKeys.weekday],
      excercises: data.containsKey(WorkoutDayRawDocKeys.excercises)
          ? (data[WorkoutDayRawDocKeys.excercises] as List<dynamic>).map((e) => WorkoutExcerciseEntity.fromMap(e)).toList()
          : null,
      muscles: data.containsKey(WorkoutDayRawDocKeys.muscles)
          ? (data[WorkoutDayRawDocKeys.muscles] as List<dynamic>)
              .map((e) => MuscleGroup.values.firstWhere((element) => describeEnum(element) == e))
              .toList()
          : null,
    );
  }

  static WorkoutDayEntity fromMap(
    Map<String, dynamic> data,
  ) {
    return WorkoutDayEntity(
      workoutId: '',
      id: data[WorkoutDayRawDocKeys.id],
      note: data.containsKey(WorkoutDayRawDocKeys.note) ? data[WorkoutDayRawDocKeys.note] : null,
      weekday: data[WorkoutDayDocKeys.weekday],
      excercises: data.containsKey(WorkoutDayRawDocKeys.excercises)
          ? (data[WorkoutDayRawDocKeys.excercises] as List<dynamic>).map((e) => WorkoutExcerciseEntity.fromMap(e)).toList()
          : null,
      muscles: data.containsKey(WorkoutDayRawDocKeys.muscles)
          ? (data[WorkoutDayRawDocKeys.muscles] as List<dynamic>)
              .map((e) => MuscleGroup.values.firstWhere((element) => describeEnum(element) == e))
              .toList()
          : null,
    );
  }
}

class WorkoutDayLogEntity extends WorkoutDayRawEntity {
  final String userId;
  final DateTime created;
  final Duration duration;

  WorkoutDayLogEntity({
    String? id,
    required String workoutId,
    List<WorkoutExcerciseEntity>? excercises,
    List<MuscleGroup>? muscles,
    String? note,
    required this.userId,
    required this.created,
    required this.duration,
  }) : super(
          id: id,
          workoutId: workoutId,
          excercises: excercises,
          muscles: muscles,
          note: note,
        );

  WorkoutDayLogEntity copyWith({
    String? userId,
    DateTime? created,
    Duration? duration,
    String? workoutId,
    List<WorkoutExcerciseEntity>? excercises,
    List<MuscleGroup>? muscles,
    String? id,
    String? note,
  }) {
    return WorkoutDayLogEntity(
      userId: userId ?? this.userId,
      created: created ?? this.created,
      duration: duration ?? this.duration,
      workoutId: workoutId ?? this.workoutId,
      excercises: excercises ?? this.excercises,
      muscles: muscles ?? this.muscles,
      id: id ?? this.id,
      note: note,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      WorkoutDayLogDocKeys.created: Timestamp.fromDate(this.created),
      WorkoutDayLogDocKeys.duration: this.duration.inMilliseconds,
      WorkoutDayLogDocKeys.userId: this.userId,
      if (this.excercises != null) WorkoutDayRawDocKeys.excercises: this.excercises!.map((e) => e.toMap()).toList(),
      if (this.muscles != null) WorkoutDayRawDocKeys.muscles: this.muscles!.map((e) => describeEnum(e)).toList(),
      if (this.note != null) WorkoutDayRawDocKeys.note: this.note,
      WorkoutDayRawDocKeys.workoutId: this.workoutId,
    };
  }

  static WorkoutDayLogEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final timestamp = data[WorkoutDayLogDocKeys.created] as Timestamp;
    return WorkoutDayLogEntity(
      workoutId: data[WorkoutDayRawDocKeys.workoutId],
      created: timestamp.toDate(),
      id: snapshot.id,
      userId: data[WorkoutDayLogDocKeys.userId],
      duration: Duration(milliseconds: data[WorkoutDayLogDocKeys.duration]),
      note: data.containsKey(WorkoutDayRawDocKeys.note) ? data[WorkoutDayRawDocKeys.note] : null,
      excercises: data.containsKey(WorkoutDayRawDocKeys.excercises)
          ? (data[WorkoutDayRawDocKeys.excercises] as List<dynamic>).map((e) => WorkoutExcerciseEntity.fromMap(e)).toList()
          : null,
      muscles: data.containsKey(WorkoutDayRawDocKeys.muscles)
          ? (data[WorkoutDayRawDocKeys.muscles] as List<dynamic>)
              .map((e) => MuscleGroup.values.firstWhere((element) => describeEnum(element) == e))
              .toList()
          : null,
    );
  }
}

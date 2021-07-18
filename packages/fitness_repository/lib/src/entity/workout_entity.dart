import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/foundation.dart';

class _DocKeys {
  static String goal = 'goal';
  static String type = 'type';
  static String duration = 'duration';
  static String daysPerWeek = 'daysPerWeek';
  static String timePerWorkout = 'timePerWorkout';
  static String startDate = 'startDate';
  static String workouts = 'workouts';
  static String note = 'note';
}

class WorkoutEntity extends Equatable {
  final String id;
  final WorkoutGoal goal;
  final WorkoutType type;
  final int duration;
  final int daysPerWeek;
  final int timePerWorkout;
  final String note;
  final DateTime startDate;
  final List<WorkoutDayEntity> workouts;

  const WorkoutEntity({
    required this.note,
    required this.id,
    required this.goal,
    required this.type,
    required this.duration,
    required this.daysPerWeek,
    required this.timePerWorkout,
    required this.startDate,
    this.workouts = const [],
  });

  @override
  List<Object> get props {
    return [
      id,
      goal,
      type,
      duration,
      daysPerWeek,
      timePerWorkout,
      note,
      startDate,
      workouts,
    ];
  }

  WorkoutEntity copyWith({
    String? id,
    WorkoutGoal? goal,
    WorkoutType? type,
    int? duration,
    int? daysPerWeek,
    int? timePerWorkout,
    String? note,
    DateTime? startDate,
    List<WorkoutDayEntity>? workouts,
  }) {
    return WorkoutEntity(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      workouts: workouts ?? this.workouts,
    );
  }

  static WorkoutEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final date = data[_DocKeys.startDate] as Timestamp;

    return WorkoutEntity(
      note: data[_DocKeys.note],
      id: snapshot.id,
      goal: WorkoutGoal.values.firstWhere((e) => describeEnum(e) == data[_DocKeys.goal]),
      type: WorkoutType.values.firstWhere((e) => describeEnum(e) == data[_DocKeys.type]),
      duration: data[_DocKeys.duration],
      daysPerWeek: data[_DocKeys.daysPerWeek],
      timePerWorkout: data[_DocKeys.timePerWorkout],
      startDate: date.toDate(),
      workouts: (data[_DocKeys.workouts] as List<dynamic>).map((e) => WorkoutDayEntity.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.note: note,
      _DocKeys.daysPerWeek: daysPerWeek,
      _DocKeys.duration: duration,
      _DocKeys.goal: describeEnum(goal),
      _DocKeys.startDate: Timestamp.fromDate(startDate),
      _DocKeys.timePerWorkout: timePerWorkout,
      _DocKeys.type: describeEnum(type),
      _DocKeys.workouts: workouts.map((e) => e.toDocumentSnapshot()).toList(),
    };
  }
}

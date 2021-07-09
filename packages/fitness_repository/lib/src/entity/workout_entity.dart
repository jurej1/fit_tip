import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:flutter/foundation.dart';

class _DocKeys {
  static String goal = 'goal';
  static String type = 'type';
  static String level = 'level';
  static String duration = 'duration';
  static String daysPerWeek = 'daysPerWeek';
  static String timePerWorkout = 'timePerWorkout';
  static String startDate = 'startDate';
  static String workouts = 'workouts';
}

class WorkoutEntity extends Equatable {
  final String id;
  final WorkoutGoal goal;
  final WorkoutType type;
  final Level level;
  final int duration;
  final int daysPerWeek;
  final int timePerWorkout;
  final DateTime startDate;
  final List<WorkoutDayEntity> workouts;
  final bool haveWorkoutsBeenFetched;

  const WorkoutEntity({
    required this.id,
    required this.goal,
    required this.type,
    required this.level,
    required this.duration,
    required this.daysPerWeek,
    required this.timePerWorkout,
    required this.startDate,
    this.haveWorkoutsBeenFetched = false,
    this.workouts = const [],
  });

  @override
  List<Object> get props {
    return [
      id,
      goal,
      type,
      level,
      duration,
      daysPerWeek,
      timePerWorkout,
      startDate,
      workouts,
      haveWorkoutsBeenFetched,
    ];
  }

  WorkoutEntity copyWith({
    String? id,
    WorkoutGoal? goal,
    WorkoutType? type,
    Level? level,
    int? duration,
    int? daysPerWeek,
    int? timePerWorkout,
    DateTime? startDate,
    List<WorkoutDayEntity>? workouts,
    bool? haveWorkoutsBeenFetched,
  }) {
    return WorkoutEntity(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      startDate: startDate ?? this.startDate,
      workouts: workouts ?? this.workouts,
      haveWorkoutsBeenFetched: haveWorkoutsBeenFetched ?? this.haveWorkoutsBeenFetched,
    );
  }

  static WorkoutEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final date = data[_DocKeys.startDate] as Timestamp;

    return WorkoutEntity(
      id: snapshot.id,
      goal: WorkoutGoal.values.firstWhere(
        (e) => describeEnum(e) == data[_DocKeys.goal],
      ),
      type: WorkoutType.values.firstWhere(
        (e) => describeEnum(e) == data[_DocKeys.type],
      ),
      level: Level.values.firstWhere(
        (e) => describeEnum(e) == data[_DocKeys.level],
      ),
      duration: data[_DocKeys.duration],
      daysPerWeek: data[_DocKeys.daysPerWeek],
      timePerWorkout: data[_DocKeys.timePerWorkout],
      startDate: date.toDate(),
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.daysPerWeek: daysPerWeek,
      _DocKeys.duration: duration,
      _DocKeys.goal: describeEnum(goal),
      _DocKeys.level: describeEnum(level),
      _DocKeys.startDate: Timestamp.fromDate(startDate),
      _DocKeys.timePerWorkout: timePerWorkout,
      _DocKeys.type: describeEnum(type),
    };
  }
}

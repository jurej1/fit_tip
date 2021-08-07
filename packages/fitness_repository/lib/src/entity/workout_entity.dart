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
  static String isActive = 'isActive';
  static String created = 'created';
  static String title = 'title';
}

class WorkoutEntity extends Equatable {
  final String id;
  final WorkoutGoal goal;
  final WorkoutType type;
  final int duration;
  final int daysPerWeek;
  final int timePerWorkout;
  final String? note;
  final DateTime startDate;
  final List<WorkoutDayEntity> workouts;
  final bool isActive;
  final DateTime created;
  final String title;

  WorkoutEntity({
    this.note,
    required this.title,
    required this.id,
    required this.goal,
    required this.type,
    required this.duration,
    required this.daysPerWeek,
    required this.timePerWorkout,
    this.isActive = false,
    required this.startDate,
    DateTime? created,
    this.workouts = const [],
  }) : this.created = created ?? DateTime.now();

  @override
  List<Object?> get props {
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
      isActive,
      created,
      title,
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
    bool? isActive,
    DateTime? created,
    String? title,
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
      isActive: isActive ?? this.isActive,
      created: created ?? this.created,
      title: title ?? this.title,
    );
  }

  static WorkoutEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final date = data[_DocKeys.startDate] as Timestamp;
    final created = data[_DocKeys.created] as Timestamp?;

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
      isActive: data[_DocKeys.isActive] ?? false,
      created: created?.toDate() ?? DateTime.now(),
      title: data.containsKey(_DocKeys.title) ? data[_DocKeys.title] : 'Test title',
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
      _DocKeys.isActive: this.isActive,
      _DocKeys.created: Timestamp.fromDate(this.created),
      _DocKeys.title: this.title,
    };
  }

  Map<String, dynamic> toWorkoutLogMap(int weekday) {
    return {
      'workoutId': this.id,
      'excercises': this
          .workouts
          .firstWhere(
            (element) => element.day == weekday,
          )
          .excercises
          .map(
        (e) {
          return {
            'excerciseId': e.id,
            'repsCountPerSet': e.repCount,
          };
        },
      ).toList(),
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Workout extends Equatable {
  final String id;
  final WorkoutGoal goal;
  final WorkoutType type;
  final int duration;
  final int daysPerWeek;
  final int timePerWorkout;
  final DateTime startDate;
  final List<WorkoutDay> workouts;
  final String? note;
  final bool isActive;
  final DateTime created;
  final String title;

  Workout({
    String? id,
    required this.title,
    this.note,
    required this.goal,
    required this.type,
    required this.duration,
    required this.daysPerWeek,
    required this.timePerWorkout,
    required this.startDate,
    this.isActive = false,
    this.workouts = const [],
    DateTime? created,
  })  : this.id = id ?? UniqueKey().toString(),
        this.created = created ?? DateTime.now();

  List<Object?> get props {
    return [
      id,
      goal,
      type,
      duration,
      daysPerWeek,
      timePerWorkout,
      startDate,
      workouts,
      note,
      isActive,
      created,
    ];
  }

  Workout copyWith({
    String? id,
    WorkoutGoal? goal,
    WorkoutType? type,
    int? duration,
    int? daysPerWeek,
    int? timePerWorkout,
    DateTime? startDate,
    List<WorkoutDay>? workouts,
    String? note,
    bool? isActive,
    DateTime? created,
    String? title,
  }) {
    return Workout(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      startDate: startDate ?? this.startDate,
      workouts: workouts ?? this.workouts,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      created: created ?? this.created,
      title: title ?? this.title,
    );
  }

  static Workout fromEntity(WorkoutEntity entity) {
    return Workout(
      note: entity.note,
      daysPerWeek: entity.daysPerWeek,
      duration: entity.duration,
      goal: entity.goal,
      id: entity.id,
      startDate: entity.startDate,
      timePerWorkout: entity.timePerWorkout,
      type: entity.type,
      workouts: entity.workouts.map((e) => WorkoutDay.fromEntity(e)).toList(),
      created: entity.created,
      isActive: entity.isActive,
      title: entity.title,
    );
  }

  WorkoutEntity toEntity() {
    return WorkoutEntity(
      note: note,
      id: id,
      goal: goal,
      type: type,
      duration: duration,
      daysPerWeek: daysPerWeek,
      timePerWorkout: timePerWorkout,
      startDate: startDate,
      workouts: workouts.map((e) => e.toEntity()).toList(),
      isActive: isActive,
      created: created,
      title: title,
    );
  }

  static List<Workout> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Workout.fromEntity(WorkoutEntity.fromDocumentSnapshot(e))).toList();
  }

  String get mapDaysPerWeekToText {
    if (daysPerWeek == 1) {
      return '$daysPerWeek day per week';
    }

    return '$daysPerWeek days per week';
  }

  String get mapDurationToText {
    if (duration == 1) return '$duration week';
    return '$duration weeks';
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, ' 'yy').format(date);
  }

  String get mapStartDateToText {
    return _formatDate(startDate);
  }

  String get mapCreatedToText {
    return _formatDate(created);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:flutter/cupertino.dart';

class Workout extends Equatable {
  final String id;
  final WorkoutGoal goal;
  final WorkoutType type;
  final int duration;
  final int daysPerWeek;
  final int timePerWorkout;
  final DateTime startDate;
  final List<WorkoutDay> workouts;

  Workout({
    String? id,
    required this.goal,
    required this.type,
    required this.duration,
    required this.daysPerWeek,
    required this.timePerWorkout,
    required this.startDate,
    this.workouts = const [],
  }) : this.id = id ?? UniqueKey().toString();

  List<Object> get props {
    return [
      id,
      goal,
      type,
      duration,
      daysPerWeek,
      timePerWorkout,
      startDate,
      workouts,
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
    );
  }

  static Workout fromEntity(WorkoutEntity entity) {
    return Workout(
      daysPerWeek: entity.daysPerWeek,
      duration: entity.duration,
      goal: entity.goal,
      id: entity.id,
      startDate: entity.startDate,
      timePerWorkout: entity.timePerWorkout,
      type: entity.type,
      workouts: entity.workouts.map((e) => WorkoutDay.fromEntity(e)).toList(),
    );
  }

  WorkoutEntity toEntity() {
    return WorkoutEntity(
      id: id,
      goal: goal,
      type: type,
      duration: duration,
      daysPerWeek: daysPerWeek,
      timePerWorkout: timePerWorkout,
      startDate: startDate,
      workouts: workouts.map((e) => e.toEntity()).toList(),
    );
  }

  static List<Workout> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Workout.fromEntity(WorkoutEntity.fromDocumentSnapshot(e))).toList();
  }
}

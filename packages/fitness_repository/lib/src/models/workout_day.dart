import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

abstract class WorkoutDayRaw extends Equatable {
  final String id;
  final String workoutId;
  final String? note;

  final List<MuscleGroup>? muscles;
  final List<WorkoutExcercise>? excercises;

  const WorkoutDayRaw({
    required this.id,
    required this.workoutId,
    this.note,
    this.muscles,
    this.excercises,
  });

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

class WorkoutDay extends WorkoutDayRaw {
  final int weekday;
  WorkoutDay({
    int? weekday,
    String? id,
    required String workoutId,
    String? note,
    List<MuscleGroup>? muscles,
    List<WorkoutExcercise>? excercises,
  })  : weekday = weekday ?? 0,
        super(
          id: id ?? UniqueKey().toString(),
          workoutId: workoutId,
          excercises: excercises,
          muscles: muscles,
          note: note,
        );

  @override
  List<Object?> get props {
    return [
      weekday,
      id,
      workoutId,
      note,
      muscles,
      excercises,
    ];
  }

  @override
  String toString() {
    return '''WorkoutDay: {
      weekday: $weekday,
      id: $id,
      workoutId: $workoutId,
      note: $note,
      muscles: ${muscles.toString()},
      excercises: ${excercises.toString()},
    }''';
  }

  String get mapDayToText {
    return DateFormat('EEEE').format(DateTime(2021, 3, this.weekday));
  }

  static String mapListIndexToText(int index) {
    final int day = _calculateDayFromIndex(index);
    return DateFormat('EEEE').format(DateTime(2021, 3, day));
  }

  static int _calculateDayFromIndex(int index) {
    return (index + 1) % 7;
  }

  WorkoutDay copyWith({
    String? id,
    String? workoutId,
    String? note,
    int? weekday,
    List<MuscleGroup>? muscles,
    List<WorkoutExcercise>? excercises,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      note: note ?? this.note,
      weekday: weekday ?? this.weekday,
      muscles: muscles ?? this.muscles,
      excercises: excercises ?? this.excercises,
    );
  }

  String getDayText() {
    return 'Day: $weekday';
  }

  static WorkoutDay fromListIndexToPure(int index) {
    return WorkoutDay(weekday: _calculateDayFromIndex(index), workoutId: '');
  }

  static WorkoutDay fromEntity(WorkoutDayEntity entity) {
    return WorkoutDay(
      workoutId: entity.workoutId,
      excercises: entity.excercises?.map((e) => WorkoutExcercise.fromEntity(e)).toList() ?? null,
      id: entity.id,
      muscles: entity.muscles,
      note: entity.note,
      weekday: entity.weekday,
    );
  }

  WorkoutDayEntity toEntity() {
    return WorkoutDayEntity(
      id: id,
      workoutId: workoutId,
      excercises: excercises?.map((e) => e.toEntity()).toList() ?? null,
      muscles: muscles,
      note: note,
      weekday: weekday,
    );
  }
}

class WorkoutDayLog extends WorkoutDayRaw {
  final String userId;
  final DateTime created;
  final Duration duration;

  WorkoutDayLog({
    required String id,
    required String workoutId,
    List<WorkoutExcercise>? excercises,
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

  @override
  List<Object?> get props {
    return [
      userId,
      created,
      duration,
      id,
      workoutId,
      note,
      muscles,
      excercises,
    ];
  }

  @override
  @override
  String toString() {
    return 'WorkoutDayLog { userId: $userId, created: $created, duration: $duration, id: $id, workoutId: $workoutId, note: $note, muscles: $muscles, excercises: $excercises,}';
  }

  WorkoutDayLog copyWith({
    String? userId,
    DateTime? created,
    Duration? duration,
    String? workoutId,
    List<WorkoutExcercise>? excercises,
    List<MuscleGroup>? muscles,
    String? id,
    String? note,
  }) {
    return WorkoutDayLog(
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

  static WorkoutDayLog fromEntity(WorkoutDayLogEntity entity) {
    return WorkoutDayLog(
      workoutId: entity.workoutId,
      userId: entity.userId,
      created: entity.created,
      duration: entity.duration,
      excercises: entity.excercises?.map((e) => WorkoutExcercise.fromEntity(e)).toList() ?? null,
      id: entity.id,
      muscles: entity.muscles,
      note: entity.note,
    );
  }

  WorkoutDayLogEntity toEntity() {
    return WorkoutDayLogEntity(
      id: id,
      workoutId: workoutId,
      userId: userId,
      created: created,
      duration: duration,
      excercises: excercises?.map((e) => e.toEntity()).toList() ?? null,
      muscles: muscles,
      note: note,
    );
  }

  int get hours => this.duration.inHours.remainder(24).toInt();
  int get minutes => this.duration.inMinutes.remainder(60).toInt();
  int get seconds => this.duration.inSeconds.remainder(60).toInt();

  DateTime get endTime => this.created.add(duration);
}

import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class WorkoutDay extends Equatable {
  final String id;
  final String? note;
  final int day;
  final List<MuscleGroup>? musclesTargeted;
  final List<WorkoutExcercise> excercises;

  WorkoutDay({
    String? id,
    this.note,
    int? day,
    this.musclesTargeted,
    int? numberOfExcercises,
    this.excercises = const [],
  })  : this.day = day ?? 0,
        this.id = id ?? UniqueKey().toString();
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

  int get numberOfMusclesTargeted => this.musclesTargeted?.length ?? 0;
  int get numberOfExcercises => this.excercises.length;

  String get mapDayToText {
    return DateFormat('EEEE').format(DateTime(2021, 3, this.day));
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
    String? note,
    int? day,
    List<MuscleGroup>? musclesTargeted,
    List<WorkoutExcercise>? excercises,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      note: note ?? this.note,
      day: day ?? this.day,
      musclesTargeted: musclesTargeted ?? this.musclesTargeted,
      excercises: excercises ?? this.excercises,
    );
  }

  static WorkoutDay fromEntity(WorkoutDayEntity entity) {
    return WorkoutDay(
      day: entity.day,
      id: entity.id,
      numberOfExcercises: entity.numberOfExcercises,
      excercises: entity.excercises.map((e) => WorkoutExcercise.fromEntity(e)).toList(),
      musclesTargeted: entity.musclesTargeted,
      note: entity.note,
    );
  }

  String getDayText() {
    return 'Day: $day';
  }

  WorkoutDayEntity toEntity() {
    return WorkoutDayEntity(
      id: id,
      day: day,
      excercises: excercises.map((e) => e.toEntity()).toList(),
      musclesTargeted: musclesTargeted,
      note: note,
    );
  }

  static WorkoutDay fromListIndexToPure(int index) {
    return WorkoutDay(day: _calculateDayFromIndex(index));
  }
}

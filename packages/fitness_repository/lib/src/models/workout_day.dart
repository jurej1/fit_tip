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
  final int numberOfExcercises;
  final List<WorkoutExcercise> excercises;
  final bool haveExcercisesBeenFetched;

  WorkoutDay({
    String? id,
    this.note,
    int? day,
    this.musclesTargeted,
    int? numberOfExcercises,
    this.haveExcercisesBeenFetched = false,
    this.excercises = const [],
  })  : this.numberOfExcercises = numberOfExcercises ?? excercises.length,
        this.day = day ?? 0,
        this.id = id ?? UniqueKey().toString();
  @override
  List<Object?> get props {
    return [
      id,
      note,
      day,
      musclesTargeted,
      numberOfExcercises,
      excercises,
      haveExcercisesBeenFetched,
    ];
  }

  int get numberOfMusclesTargeted => this.musclesTargeted?.length ?? 0;

  String get mapDayToText {
    return DateFormat('EEEE').format(DateTime(0, 0, this.day));
  }

  WorkoutDay copyWith({
    String? id,
    String? note,
    int? day,
    List<MuscleGroup>? musclesTargeted,
    int? numberOfExcercises,
    List<WorkoutExcercise>? excercises,
    bool? haveExcercisesBeenFetched,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      note: note ?? this.note,
      day: day ?? this.day,
      musclesTargeted: musclesTargeted ?? this.musclesTargeted,
      numberOfExcercises: numberOfExcercises ?? this.numberOfExcercises,
      excercises: excercises ?? this.excercises,
      haveExcercisesBeenFetched: haveExcercisesBeenFetched ?? this.haveExcercisesBeenFetched,
    );
  }

  static WorkoutDay fromEntity(WorkoutDayEntity entity) {
    return WorkoutDay(
      day: entity.day,
      id: entity.id,
      numberOfExcercises: entity.numberOfExcercises,
      excercises: entity.excercises.map((e) => WorkoutExcercise.fromEntity(e)).toList(),
      haveExcercisesBeenFetched: entity.haveExcercisesBeenFetched,
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
      haveExcercisesBeenFetched: haveExcercisesBeenFetched,
      musclesTargeted: musclesTargeted,
      note: note,
    );
  }
}

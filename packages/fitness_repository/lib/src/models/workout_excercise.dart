import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:fitness_repository/src/enums/enums.dart';

class WorkoutExcercise extends Equatable {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final RepUnit repUnit;
  final List<int>? repsAcomplishedForEachSet;

  const WorkoutExcercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.repUnit,
    this.repsAcomplishedForEachSet,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      sets,
      reps,
      repUnit,
      repsAcomplishedForEachSet,
    ];
  }

  WorkoutExcercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    RepUnit? repUnit,
    List<int>? repsAcomplishedForEachSet,
  }) {
    return WorkoutExcercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      repUnit: repUnit ?? this.repUnit,
      repsAcomplishedForEachSet: repsAcomplishedForEachSet ?? this.repsAcomplishedForEachSet,
    );
  }

  static WorkoutExcercise fromEntity(WorkoutExcerciseEntity entity) {
    return WorkoutExcercise(id: entity.id, name: entity.name, sets: entity.sets, reps: entity.reps, repUnit: entity.repUnit);
  }

  WorkoutExcerciseEntity toEntity() {
    return WorkoutExcerciseEntity(id: id, name: name, sets: sets, reps: reps, repUnit: repUnit);
  }

  String get repsString => reps.toStringAsFixed(0);
  String get setsString => sets.toStringAsFixed(0);
}

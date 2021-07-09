import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

class WorkoutDay extends Equatable {
  final String id;
  final String? note;
  final int day;
  final List<MuscleGroup>? musclesTargeted;
  final int numberOfExcercises;
  final List<WorkoutExcercise> excercises;

  WorkoutDay({
    required this.id,
    this.note,
    required this.day,
    this.musclesTargeted,
    required this.numberOfExcercises,
    this.excercises = const [],
  });

  @override
  List<Object?> get props {
    return [
      id,
      note,
      day,
      musclesTargeted,
      numberOfExcercises,
      excercises,
    ];
  }

  WorkoutDay copyWith({
    String? id,
    String? note,
    int? day,
    List<MuscleGroup>? musclesTargeted,
    int? numberOfExcercises,
    List<WorkoutExcercise>? excercises,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      note: note ?? this.note,
      day: day ?? this.day,
      musclesTargeted: musclesTargeted ?? this.musclesTargeted,
      numberOfExcercises: numberOfExcercises ?? this.numberOfExcercises,
      excercises: excercises ?? this.excercises,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:fitness_repository/src/entity/entity.dart';
import 'package:fitness_repository/src/enums/enums.dart';
import 'package:fitness_repository/src/models/models.dart';

class WorkoutDayLog extends Equatable {
  final String id;
  final String workoutId;
  final String workoutDayId;
  final List<MuscleGroup>? musclesTargeted;
  final List<WorkoutExcercise> excercises;
  final DateTime created;
  final Duration duration;

  const WorkoutDayLog({
    required this.id,
    required this.workoutId,
    required this.workoutDayId,
    required this.excercises,
    required this.created,
    this.musclesTargeted,
    this.duration = Duration.zero,
  });

  @override
  List<Object?> get props {
    return [
      id,
      workoutId,
      workoutDayId,
      musclesTargeted,
      excercises,
      created,
      duration,
    ];
  }

  WorkoutDayLog copyWith({
    String? id,
    String? workoutId,
    String? workoutDayId,
    List<MuscleGroup>? musclesTargeted,
    List<WorkoutExcercise>? excercises,
    DateTime? created,
    Duration? duration,
  }) {
    return WorkoutDayLog(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      musclesTargeted: musclesTargeted ?? this.musclesTargeted,
      excercises: excercises ?? this.excercises,
      created: created ?? this.created,
      duration: duration ?? this.duration,
    );
  }

  factory WorkoutDayLog.fromEntity(WorkoutDayLogEntity entity) {
    return WorkoutDayLog(
      id: entity.id,
      workoutId: entity.workoutId,
      workoutDayId: entity.workoutDayId,
      excercises: entity.excercises.map((e) => WorkoutExcercise.fromEntity(e)).toList(),
      created: entity.created,
      musclesTargeted: entity.musclesTargeted,
      duration: entity.duration,
    );
  }

  WorkoutDayLogEntity toEntity() {
    return WorkoutDayLogEntity(
      id: id,
      workoutId: workoutId,
      workoutDayId: workoutDayId,
      excercises: excercises.map((e) => e.toEntity()).toList(),
      created: created,
      musclesTargeted: musclesTargeted,
      duration: duration,
    );
  }

  int get hours => this.duration.inHours.remainder(24).toInt();
  int get minutes => this.duration.inMinutes.remainder(60).toInt();
  int get seconds => this.duration.inSeconds.remainder(60).toInt();

  DateTime get endTime => this.created.add(duration);
}

import 'dart:convert';

import 'package:activity_repository/activity_repository.dart';
import 'package:activity_repository/src/entity/entity.dart';
import 'package:equatable/equatable.dart';

class ExcerciseLog extends Equatable {
  final String id;
  final String name;
  final int duration;
  final Intensity intensity;
  final int calories;
  final DateTime startTime;
  final ExcerciseType type;

  const ExcerciseLog({
    String? id,
    required this.name,
    required this.duration,
    required this.intensity,
    required this.calories,
    required this.startTime,
    required this.type,
  }) : this.id = id ?? '';

  @override
  List<Object> get props {
    return [
      id,
      name,
      duration,
      intensity,
      calories,
      startTime,
      type,
    ];
  }

  ExcerciseLog copyWith({
    String? id,
    String? name,
    int? duration,
    Intensity? intensity,
    int? calories,
    DateTime? startTime,
    ExcerciseType? type,
  }) {
    return ExcerciseLog(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      calories: calories ?? this.calories,
      startTime: startTime ?? this.startTime,
      type: type ?? this.type,
    );
  }

  ExcerciseLogEntity toEntity() {
    return ExcerciseLogEntity(
      id: id,
      type: type,
      name: name,
      duration: duration,
      intensity: intensity,
      calories: calories,
      startTime: startTime,
    );
  }

  static ExcerciseLog fromEntity(ExcerciseLogEntity entity) {
    return ExcerciseLog(
      type: entity.type,
      name: entity.name,
      duration: entity.duration,
      intensity: entity.intensity,
      calories: entity.calories,
      startTime: entity.startTime,
      id: entity.id,
    );
  }
}

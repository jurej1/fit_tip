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

  const ExcerciseLog({
    String? id,
    required this.name,
    required this.duration,
    required this.intensity,
    required this.calories,
    required this.startTime,
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
    ];
  }

  ExcerciseLog copyWith({
    String? id,
    String? name,
    int? duration,
    Intensity? intensity,
    int? calories,
    DateTime? startTime,
  }) {
    return ExcerciseLog(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      calories: calories ?? this.calories,
      startTime: startTime ?? this.startTime,
    );
  }

  ExcerciseLogEntity toEntity() {
    return ExcerciseLogEntity(
      name: name,
      duration: duration,
      intensity: intensity,
      calories: calories,
      startTime: startTime,
    );
  }

  static ExcerciseLog fromEntity(ExcerciseLog entity) {
    return ExcerciseLog(
      name: entity.name,
      duration: entity.duration,
      intensity: entity.intensity,
      calories: entity.calories,
      startTime: entity.startTime,
    );
  }
}

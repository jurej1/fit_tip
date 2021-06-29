import 'package:activity_repository/src/enums/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class _DocKeys {
  static String name = 'name';
  static String duration = 'duration';
  static String intensity = 'intensity';
  static String calories = 'calories';
  static String startTime = 'startTime';
}

class ExcerciseLogEntity extends Equatable {
  final String id;
  final String name;
  final int duration;
  final Intensity intensity;
  final int calories;
  final DateTime startTime;

  ExcerciseLogEntity({
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

  ExcerciseLogEntity copyWith({
    String? id,
    String? name,
    int? duration,
    Intensity? intensity,
    int? calories,
    DateTime? startTime,
  }) {
    return ExcerciseLogEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      calories: calories ?? this.calories,
      startTime: startTime ?? this.startTime,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.calories: this.calories,
      _DocKeys.duration: this.duration,
      _DocKeys.intensity: describeEnum(this.intensity),
      _DocKeys.name: this.name,
      _DocKeys.startTime: Timestamp.fromDate(this.startTime),
    };
  }

  static ExcerciseLogEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return ExcerciseLogEntity(
      name: data[_DocKeys.name],
      duration: data[_DocKeys.duration],
      intensity: Intensity.values.firstWhere(
        (e) => describeEnum(e) == describeEnum(data[_DocKeys.intensity]),
      ),
      calories: data[_DocKeys.calories],
      startTime: data[_DocKeys.startTime],
    );
  }
}

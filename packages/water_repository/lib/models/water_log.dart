import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:water_repository/entity/water_log_entity.dart';

import 'models.dart';

class WaterLog extends Equatable {
  final String id;
  final WaterCup cup;
  final TimeOfDay time;
  final DateTime date;

  const WaterLog({
    required this.id,
    required this.cup,
    required this.time,
    required this.date,
  });

  @override
  List<Object> get props => [id, cup, time, date];

  WaterLog copyWith({
    String? id,
    WaterCup? cup,
    TimeOfDay? time,
    DateTime? date,
  }) {
    return WaterLog(
      id: id ?? this.id,
      cup: cup ?? this.cup,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }

  WaterLogEntity toEntity() {
    return WaterLogEntity(
      id: id,
      cup: cup.toEntity(),
      date: date,
      time: time,
    );
  }

  factory WaterLog.fromEntity(WaterLogEntity entity) {
    return WaterLog(
      cup: WaterCup.fromEntity(entity.cup),
      date: entity.date,
      time: entity.time,
      id: entity.id,
    );
  }
}

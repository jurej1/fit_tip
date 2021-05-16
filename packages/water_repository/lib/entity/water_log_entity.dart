import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:water_repository/entity/water_cup_entity.dart';

class WaterLogEntity extends Equatable {
  final WaterCupEntity cup;
  final TimeOfDay time;
  final DateTime date;

  const WaterLogEntity({
    required this.cup,
    required this.time,
    required this.date,
  });

  @override
  List<Object> get props => [cup, time, date];

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'cup': cup.toDocumentSnapshot(),
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day, time.hour, time.minute)),
    };
  }

  factory WaterLogEntity.fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map;

    final date = data['date'] as Timestamp;
    final dateTime = date.toDate();

    return WaterLogEntity(
      cup: data['cup'],
      time: TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      ),
      date: DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weight_repository/enums/enums.dart';
import 'package:weight_repository/models/models.dart';

class _DocKeys {
  static String get id => 'id';
  static String get targetWeight => 'target_weight';
  static String get beginDate => 'begin_date';
  static String get targetDate => 'target_date';
  static String get beginWeight => 'begin_weight';
  static String get weeklyGoal => 'weekly_goal';
}

class WeightGoalEntity extends Equatable {
  final String? id;
  final double? targetWeight;
  final Timestamp? beginDate;
  final Timestamp? targetDate;
  final double? beginWeight;
  final WeeklyGoal weeklyGoal;

  const WeightGoalEntity({
    required this.id,
    this.targetWeight,
    this.beginDate,
    this.targetDate,
    this.beginWeight,
    this.weeklyGoal = WeeklyGoal.maintain,
  });

  @override
  List<Object?> get props {
    return [
      id,
      targetWeight,
      beginDate,
      targetDate,
      beginWeight,
      weeklyGoal,
    ];
  }

  WeightGoalEntity copyWith({
    String? id,
    double? targetWeight,
    Timestamp? beginDate,
    Timestamp? targetDate,
    double? beginWeight,
    WeeklyGoal? weeklyGoal,
  }) {
    return WeightGoalEntity(
      id: id ?? this.id,
      targetWeight: targetWeight ?? this.targetWeight,
      beginDate: beginDate ?? this.beginDate,
      targetDate: targetDate ?? this.targetDate,
      beginWeight: beginWeight ?? this.beginWeight,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      if (targetWeight != null) _DocKeys.targetWeight: this.targetWeight,
      if (beginDate != null) _DocKeys.beginDate: this.beginDate,
      if (targetDate != null) _DocKeys.targetDate: this.targetDate,
      if (beginWeight != null) _DocKeys.beginWeight: this.beginWeight,
      _DocKeys.weeklyGoal: describeEnum(this.weeklyGoal),
    };
  }

  WeightGoal toWeightGoal() {
    return WeightGoal(
      beginDate: this.beginDate?.toDate(),
      beginWeight: this.beginWeight,
      id: this.id,
      targetDate: this.targetDate?.toDate(),
      targetWeight: this.targetWeight,
      weeklyGoal: this.weeklyGoal,
    );
  }

  static WeightGoalEntity fromWeightGoal(WeightGoal weight) {
    return WeightGoalEntity(
      id: weight.id,
      beginDate: weight.beginDate == null ? null : Timestamp.fromDate(weight.beginDate!),
      beginWeight: weight.beginWeight,
      targetDate: weight.targetDate == null ? null : Timestamp.fromDate(weight.targetDate!),
      targetWeight: weight.targetWeight,
      weeklyGoal: weight.weeklyGoal,
    );
  }

  static WeightGoalEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    return WeightGoalEntity(
      id: snap.id,
      beginDate: data?[_DocKeys.beginDate],
      beginWeight: data?[_DocKeys.beginWeight],
      targetDate: data?[_DocKeys.targetDate],
      targetWeight: data?[_DocKeys.targetWeight],
      weeklyGoal: mapDatabaseStringToWeeklyGoal(data?[_DocKeys.weeklyGoal]),
    );
  }
}

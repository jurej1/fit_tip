import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_repository/entity/entity.dart';

class WeightGoal extends Equatable {
  final String? id;
  final double? targetWeight;
  final DateTime? beginDate;
  final DateTime? targetDate;
  final double? beginWeight;
  final double weeklyGoal;

  const WeightGoal({
    this.id,
    this.targetWeight,
    this.beginDate,
    this.targetDate,
    this.beginWeight,
    this.weeklyGoal = 0.0,
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

  WeightGoal copyWith({
    String? id,
    double? targetWeight,
    DateTime? beginDate,
    DateTime? targetDate,
    double? beginWeight,
    double? weeklyGoal,
  }) {
    return WeightGoal(
      id: id ?? this.id,
      targetWeight: targetWeight ?? this.targetWeight,
      beginDate: beginDate ?? this.beginDate,
      targetDate: targetDate ?? this.targetDate,
      beginWeight: beginWeight ?? this.beginWeight,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
    );
  }

  WeightGoalEntity toEntity() {
    return WeightGoalEntity(
      id: this.id,
      beginDate: this.beginDate == null ? null : Timestamp.fromDate(this.beginDate!),
      beginWeight: this.beginWeight,
      targetDate: this.targetDate == null ? null : Timestamp.fromDate(this.targetDate!),
      targetWeight: this.targetWeight,
      weeklyGoal: this.weeklyGoal,
    );
  }

  static WeightGoal fromEntity(WeightGoalEntity entity) {
    return WeightGoal(
      beginDate: entity.beginDate?.toDate(),
      beginWeight: entity.beginWeight,
      id: entity.id,
      targetDate: entity.targetDate?.toDate(),
      targetWeight: entity.targetWeight,
      weeklyGoal: entity.weeklyGoal,
    );
  }
}

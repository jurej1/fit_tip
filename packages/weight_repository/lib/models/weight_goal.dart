import 'package:equatable/equatable.dart';

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
}

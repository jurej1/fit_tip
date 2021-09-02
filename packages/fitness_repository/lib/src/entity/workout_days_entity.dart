import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'entity.dart';

class WorkoutDaysDocKeys {
  static String workoutDays = 'workoutDays';
  static String workoutId = 'workoutId';
}

class WorkoutDaysEntity extends Equatable {
  final List<WorkoutDayEntity>? workoutDays;
  final String workoutId;

  const WorkoutDaysEntity({
    this.workoutDays,
    required this.workoutId,
  });

  @override
  List<Object?> get props => [workoutDays, workoutId];

  WorkoutDaysEntity copyWith({
    List<WorkoutDayEntity>? workoutDays,
    String? workoutId,
  }) {
    return WorkoutDaysEntity(
      workoutDays: workoutDays ?? this.workoutDays,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      if (this.workoutDays != null) WorkoutDaysDocKeys.workoutDays: workoutDays!.map((e) => e.toDocumentSnapshot()).toList(),
      WorkoutDaysDocKeys.workoutId: this.workoutId,
    };
  }

  static WorkoutDaysEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WorkoutDaysEntity(
      workoutId: data[WorkoutDaysDocKeys.workoutId],
      workoutDays: (data[WorkoutDaysDocKeys.workoutDays] as List<dynamic>).map((e) => WorkoutDayEntity.fromMap(e)).toList(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/entity.dart';

class WorkoutDocKeys {
  static String info = 'info';
  static String workoutDays = 'workoutDays';
}

class WorkoutEntity extends Equatable {
  final bool isActive;
  final DateTime? startDate;
  final WorkoutInfoEntity workoutInfoEntity;
  final WorkoutDaysEntity? workoutDaysEntity;

  const WorkoutEntity(
    this.workoutInfoEntity, {
    this.workoutDaysEntity,
    this.isActive = false,
    this.startDate,
  });

  @override
  List<Object?> get props => [workoutInfoEntity, workoutDaysEntity, isActive, startDate];

  WorkoutEntity copyWith({
    WorkoutInfoEntity? workoutInfoEntity,
    WorkoutDaysEntity? workoutDaysEntity,
    bool? isActive,
    DateTime? startDate,
  }) {
    return WorkoutEntity(
      workoutInfoEntity ?? this.workoutInfoEntity,
      workoutDaysEntity: workoutDaysEntity ?? this.workoutDaysEntity,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
    );
  }
}

class ActiveWorkoutDocKeys {
  static String startDate = 'startDate';
  static String ctiveWorkoutId = 'ctiveWorkoutId';
}

class ActiveWorkoutEntity extends Equatable {
  final ActiveWorkoutInfoEntity activeWorkoutInfoEntity;
  final WorkoutDaysEntity? workoutDaysEntity;

  ActiveWorkoutEntity(
    this.activeWorkoutInfoEntity, {
    this.workoutDaysEntity,
  });

  @override
  List<Object?> get props => [activeWorkoutInfoEntity, workoutDaysEntity];

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      WorkoutDocKeys.info: this.activeWorkoutInfoEntity.toActiveMap(),
      if (this.workoutDaysEntity != null) WorkoutDocKeys.workoutDays: this.workoutDaysEntity!.toMap(),
    };
  }

  static ActiveWorkoutEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ActiveWorkoutEntity(
      ActiveWorkoutInfoEntity.fromActiveMap(data[WorkoutDocKeys.info], snapshot.id),
      workoutDaysEntity: WorkoutDaysEntity.fromMap(data[WorkoutDocKeys.workoutDays]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:fitness_repository/src/entity/entity.dart';

class WorkoutDocKeys {
  static String info = 'info';
  static String workoutDays = 'workoutDays';
}

abstract class WorkoutEntityX extends Equatable {
  final WorkoutInfoEntity info;
  final WorkoutDaysEntity? workoutDays;

  const WorkoutEntityX(
    this.info, {
    this.workoutDays,
  });

  @override
  List<Object?> get props => [info, workoutDays];
}

class WorkoutEntity extends WorkoutEntityX {
  final bool isActive;
  final DateTime? startDate;

  const WorkoutEntity(
    WorkoutInfoEntity info, {
    WorkoutDaysEntity? workoutDays,
    this.isActive = false,
    this.startDate,
  }) : super(info, workoutDays: workoutDays);

  @override
  List<Object?> get props => [info, workoutDays, isActive, startDate];

  WorkoutEntity copyWith({
    WorkoutInfoEntity? info,
    WorkoutDaysEntity? workoutDays,
    bool? isActive,
    DateTime? startDate,
  }) {
    return WorkoutEntity(
      info ?? this.info,
      workoutDays: workoutDays ?? this.workoutDays,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
    );
  }

  // Map<String, dynamic> toDocumentSnapshot() {
  //   return {
  //     WorkoutDocKeys.info: this.info.toDocumentSnapshot(),
  //     WorkoutDocKeys.isActive: this.isActive,
  //     if (this.startDate != null) WorkoutDocKeys.startDate: Timestamp.fromDate(this.startDate!),
  //     if (this.workoutDays != null) WorkoutDocKeys.workoutDays: this.workoutDays?.toDocumentSnapshot()
  //   };
  // }

  // WorkoutEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
  //   return WorkoutEntity(info);
  // }
}

class ActiveWorkoutDocKeys {
  static String startDate = 'startDate';
  static String ctiveWorkoutId = 'ctiveWorkoutId';
}

class ActiveWorkoutEntity extends WorkoutEntityX {
  final DateTime startDate;
  final String activeWorkoutId;

  ActiveWorkoutEntity(
    WorkoutInfoEntity info, {
    WorkoutDaysEntity? workoutDaysEntity,
    required this.startDate,
    required this.activeWorkoutId,
  }) : super(info, workoutDays: workoutDaysEntity);

  @override
  List<Object?> get props => [startDate, activeWorkoutId, info, workoutDays];

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      ActiveWorkoutDocKeys.ctiveWorkoutId: this.activeWorkoutId,
      ActiveWorkoutDocKeys.startDate: Timestamp.fromDate(this.startDate),
      WorkoutDocKeys.info: this.info.toActiveMap(),
      if (this.workoutDays != null) WorkoutDocKeys.workoutDays: this.workoutDays!.toMap(),
    };
  }

  static ActiveWorkoutEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final timestamp = data[ActiveWorkoutDocKeys.startDate] as Timestamp;
    return ActiveWorkoutEntity(
      WorkoutInfoEntity.fromActiveMap(data[WorkoutDocKeys.info]),
      startDate: timestamp.toDate(),
      activeWorkoutId: snapshot.id,
      workoutDaysEntity: WorkoutDaysEntity.fromMap(data[WorkoutDocKeys.workoutDays]),
    );
  }
}

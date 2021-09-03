import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

abstract class WorkoutX extends Equatable {
  final WorkoutInfo info;
  final WorkoutDays? workoutDays;

  WorkoutX({
    required this.info,
    this.workoutDays,
  });

  List<Object?> get props => [info, workoutDays];

  static String dateTimeToWorkoutLogId(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }
}

class Workout extends WorkoutX {
  Workout({
    required WorkoutInfo info,
    WorkoutDays? workoutDays,
  }) : super(
          info: info,
          workoutDays: workoutDays,
        );

  List<Object?> get props => [info, workoutDays];

  factory Workout.pure() {
    return Workout(
      info: WorkoutInfo(
        uid: '',
        id: '',
        daysPerWeek: 0,
        title: '',
        duration: 0,
      ),
    );
  }

  Workout copyWith({
    WorkoutInfo? info,
    WorkoutDays? workoutDays,
  }) {
    return Workout(
      info: info ?? this.info,
      workoutDays: workoutDays ?? this.workoutDays,
    );
  }
}

class ActiveWorkout extends WorkoutX {
  final bool isActive;
  final DateTime startDate;
  final String activeWorkoutId;

  ActiveWorkout({
    this.isActive = false,
    required this.startDate,
    required this.activeWorkoutId,
    required WorkoutInfo info,
    WorkoutDays? workoutDays,
  }) : super(info: info, workoutDays: workoutDays);

  ActiveWorkout copyWith({
    bool? isActive,
    DateTime? startDate,
    WorkoutDays? workoutDays,
    WorkoutInfo? info,
    String? activeWorkoutId,
  }) {
    return ActiveWorkout(
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      info: info ?? this.info,
      workoutDays: workoutDays ?? this.workoutDays,
      activeWorkoutId: activeWorkoutId ?? this.activeWorkoutId,
    );
  }

  ActiveWorkoutEntity toEntity() {
    return ActiveWorkoutEntity(
      this.info.toEntity(),
      workoutDaysEntity: this.workoutDays?.toEntity(),
      startDate: startDate,
      activeWorkoutId: activeWorkoutId,
    );
  }

  static ActiveWorkout fromEntity(ActiveWorkoutEntity entity) {
    return ActiveWorkout(
      startDate: entity.startDate,
      activeWorkoutId: entity.activeWorkoutId,
      info: WorkoutInfo.fromEntiy(entity.info),
      isActive: false,
      workoutDays: entity.workoutDays != null ? WorkoutDays.fromEntity(entity.workoutDays!) : null,
    );
  }

  DateTime get lastDate {
    return this.startDate.add(Duration(days: this.info.duration * 7));
  }

  static List<ActiveWorkout> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    //TODO: isActive
    return querySnapshot.docs.map((e) {
      ActiveWorkout workout = ActiveWorkout.fromEntity(
        ActiveWorkoutEntity.fromDocumentSnapshot(e),
      );
      return workout;
    }).toList();
  }
}

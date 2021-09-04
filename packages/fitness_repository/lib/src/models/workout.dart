import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

abstract class WorkoutX extends Equatable {
  final WorkoutInfoX info;
  final WorkoutDays? workoutDays;

  WorkoutX({
    required this.info,
    this.workoutDays,
  });

  List<Object?> get props => [info, workoutDays];

  static String dateTimeToWorkoutLogId(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  factory WorkoutX.fromInfo(WorkoutInfoX info) {
    if (info is ActiveWorkoutInfo) {
      return ActiveWorkout(info: info);
    } else {
      return Workout(info: info as WorkoutInfo);
    }
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
      info: info ?? this.info as WorkoutInfo,
      workoutDays: workoutDays,
    );
  }
}

class ActiveWorkout extends WorkoutX {
  ActiveWorkout({
    required ActiveWorkoutInfo info,
    WorkoutDays? workoutDays,
  }) : super(info: info, workoutDays: workoutDays);

  ActiveWorkout copyWith({
    WorkoutDays? workoutDays,
    ActiveWorkoutInfo? info,
    String? activeWorkoutId,
  }) {
    return ActiveWorkout(
      info: info ?? this.info as ActiveWorkoutInfo,
      workoutDays: workoutDays ?? this.workoutDays,
    );
  }

  ActiveWorkoutEntity toEntity() {
    return ActiveWorkoutEntity(
      (this.info as ActiveWorkoutInfo).toEntity(),
      workoutDaysEntity: this.workoutDays?.toEntity(),
    );
  }

  static ActiveWorkout fromEntity(ActiveWorkoutEntity entity) {
    return ActiveWorkout(
      info: ActiveWorkoutInfo.fromEntity(entity.activeWorkoutInfoEntity),
      workoutDays: entity.workoutDaysEntity != null ? WorkoutDays.fromEntity(entity.workoutDaysEntity!) : null,
    );
  }

  DateTime get lastDate {
    return (this.info as ActiveWorkoutInfo).startDate.add(Duration(days: this.info.duration * 7));
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

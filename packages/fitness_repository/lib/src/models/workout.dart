import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

abstract class WorkoutRaw extends Equatable {
  final WorkoutInfoRaw _info;
  final WorkoutDays? workoutDays;

  WorkoutRaw({
    required WorkoutInfoRaw info,
    this.workoutDays,
  }) : _info = info;

  List<Object?> get props => [_info, workoutDays];

  static String dateTimeToWorkoutLogId(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  factory WorkoutRaw.fromInfo(WorkoutInfoRaw info) {
    if (info is ActiveWorkoutInfo) {
      return ActiveWorkout(info: info);
    } else {
      return Workout(info: info as WorkoutInfo);
    }
  }
}

class Workout extends WorkoutRaw {
  Workout({
    required WorkoutInfo info,
    WorkoutDays? workoutDays,
  }) : super(
          info: info,
          workoutDays: workoutDays,
        );

  WorkoutInfo get info => this._info as WorkoutInfo;

  List<Object?> get props => [_info, workoutDays];

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
      info: info ?? this._info as WorkoutInfo,
      workoutDays: workoutDays,
    );
  }
}

class ActiveWorkout extends WorkoutRaw {
  ActiveWorkout({
    required ActiveWorkoutInfo info,
    WorkoutDays? workoutDays,
  }) : super(info: info, workoutDays: workoutDays);

  ActiveWorkoutInfo get info => this._info as ActiveWorkoutInfo;

  ActiveWorkout copyWith({
    WorkoutDays? workoutDays,
    ActiveWorkoutInfo? info,
  }) {
    return ActiveWorkout(
      info: info ?? this._info as ActiveWorkoutInfo,
      workoutDays: workoutDays ?? this.workoutDays,
    );
  }

  ActiveWorkoutEntity toEntity() {
    return ActiveWorkoutEntity(
      (this._info as ActiveWorkoutInfo).toEntity(),
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
    return (this._info as ActiveWorkoutInfo).startDate.add(Duration(days: this._info.duration * 7));
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

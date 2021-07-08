import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static String caloriesBurnedPerWeek = 'caloriesBurnedPerWeek';
  static String workoutsPerWeek = 'workoutsPerWeek';
  static String minutesPerWorkout = 'minutesPerWorkout';
  static String minutesPerDay = 'minutesPerDay';
  static String date = 'date';
}

class ExcerciseDailyGoalEntity extends Equatable {
  final int caloriesBurnedPerWeek;
  final int workoutsPerWeek;
  final int minutesPerWorkout;
  final int minutesPerDay;
  final String id;
  final DateTime date;

  ExcerciseDailyGoalEntity({
    this.caloriesBurnedPerWeek = 0,
    this.workoutsPerWeek = 0,
    this.minutesPerWorkout = 0,
    this.minutesPerDay = 60,
    String? id,
    DateTime? date,
  })  : this.id = id ?? generateId(date ?? DateTime.now()),
        this.date = date ?? DateTime.now();

  @override
  List<Object> get props {
    return [
      caloriesBurnedPerWeek,
      workoutsPerWeek,
      minutesPerWorkout,
      minutesPerDay,
      id,
      date,
    ];
  }

  ExcerciseDailyGoalEntity copyWith({
    int? caloriesBurnedPerWeek,
    int? workoutsPerWeek,
    int? minutesPerWorkout,
    int? minutesPerDay,
    String? id,
    DateTime? date,
  }) {
    return ExcerciseDailyGoalEntity(
      caloriesBurnedPerWeek: caloriesBurnedPerWeek ?? this.caloriesBurnedPerWeek,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      minutesPerWorkout: minutesPerWorkout ?? this.minutesPerWorkout,
      minutesPerDay: minutesPerDay ?? this.minutesPerDay,
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }

  static String generateId(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      _DocKeys.caloriesBurnedPerWeek: caloriesBurnedPerWeek,
      _DocKeys.minutesPerDay: minutesPerDay,
      _DocKeys.minutesPerWorkout: minutesPerWorkout,
      _DocKeys.workoutsPerWeek: workoutsPerWeek,
      _DocKeys.date: date,
    };
  }

  static ExcerciseDailyGoalEntity fromDocumentSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    final dateTimestamp = data[_DocKeys.date] as Timestamp;
    return ExcerciseDailyGoalEntity(
      caloriesBurnedPerWeek: data[_DocKeys.caloriesBurnedPerWeek],
      date: dateTimestamp.toDate(),
      id: snap.id,
      minutesPerDay: data[_DocKeys.minutesPerDay],
      minutesPerWorkout: data[_DocKeys.minutesPerWorkout],
      workoutsPerWeek: data[_DocKeys.workoutsPerWeek],
    );
  }
}

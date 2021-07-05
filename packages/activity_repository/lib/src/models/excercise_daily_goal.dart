import 'package:activity_repository/src/entity/entity.dart';
import 'package:equatable/equatable.dart';

class ExcerciseDailyGoal extends Equatable {
  final int caloriesBurnedPerDay;
  final int workoutsPerWeek;
  final int minutesPerWorkout;
  final int minutesPerDay;
  final String id;
  final DateTime date;

  ExcerciseDailyGoal({
    this.caloriesBurnedPerDay = 300,
    this.workoutsPerWeek = 3,
    this.minutesPerWorkout = 30,
    this.minutesPerDay = 60,
    String? id,
    DateTime? date,
  })  : this.id = id ?? generateId(date ?? DateTime.now()),
        this.date = date ?? DateTime.now();

  @override
  List<Object> get props {
    return [
      caloriesBurnedPerDay,
      workoutsPerWeek,
      minutesPerWorkout,
      minutesPerDay,
      id,
      date,
    ];
  }

  ExcerciseDailyGoal copyWith({
    int? caloriesBurnedPerWeek,
    int? workoutsPerWeek,
    int? minutesPerWorkout,
    int? minutesPerDay,
    String? id,
    DateTime? date,
  }) {
    return ExcerciseDailyGoal(
      caloriesBurnedPerDay: caloriesBurnedPerWeek ?? this.caloriesBurnedPerDay,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      minutesPerWorkout: minutesPerWorkout ?? this.minutesPerWorkout,
      minutesPerDay: minutesPerDay ?? this.minutesPerDay,
      id: id ?? this.id,
      date: date ?? this.date,
    );
  }

  static String generateId(DateTime date) {
    return ExcerciseDailyGoalEntity.generateId(date);
  }

  ExcerciseDailyGoalEntity toEntity() {
    return ExcerciseDailyGoalEntity(
      caloriesBurnedPerWeek: caloriesBurnedPerDay,
      date: date,
      id: id,
      minutesPerDay: minutesPerDay,
      minutesPerWorkout: minutesPerWorkout,
      workoutsPerWeek: workoutsPerWeek,
    );
  }

  factory ExcerciseDailyGoal.fromEntity(ExcerciseDailyGoalEntity entity) {
    return ExcerciseDailyGoal(
      caloriesBurnedPerDay: entity.caloriesBurnedPerWeek,
      date: entity.date,
      id: entity.id,
      minutesPerDay: entity.minutesPerDay,
      minutesPerWorkout: entity.minutesPerWorkout,
      workoutsPerWeek: entity.workoutsPerWeek,
    );
  }
}

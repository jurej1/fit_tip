import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

class Workout extends Equatable {
  final String id;
  final WorkoutGoal goal;
  final WorkoutType type;
  final Level level;
  final int duration;
  final int daysPerWeek;
  final int timePerWorkout;
  final DateTime startDate;
  final List<WorkoutDay> workouts;

  const Workout({
    required this.id,
    required this.goal,
    required this.type,
    required this.level,
    required this.duration,
    required this.daysPerWeek,
    required this.timePerWorkout,
    required this.startDate,
    this.workouts = const [],
  });

  List<Object> get props {
    return [
      id,
      goal,
      type,
      level,
      duration,
      daysPerWeek,
      timePerWorkout,
      startDate,
      workouts,
    ];
  }

  Workout copyWith({
    String? id,
    WorkoutGoal? goal,
    WorkoutType? type,
    Level? level,
    int? duration,
    int? daysPerWeek,
    int? timePerWorkout,
    DateTime? startDate,
    List<WorkoutDay>? workouts,
  }) {
    return Workout(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      startDate: startDate ?? this.startDate,
      workouts: workouts ?? this.workouts,
    );
  }
}

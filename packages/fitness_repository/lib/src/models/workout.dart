import 'package:equatable/equatable.dart';
import 'package:fitness_repository/fitness_repository.dart';

class Workout extends Equatable {
  final WorkoutInfo info;
  final WorkoutDays? workoutDays;

  final bool isActive;
  final DateTime? startDate;

  Workout({
    required this.info,
    this.workoutDays,
    this.isActive = false,
    DateTime? startDate,
  }) : this.startDate = startDate;

  List<Object?> get props => [info, workoutDays, isActive, startDate];

  factory Workout.pure() {
    return Workout(
      info: WorkoutInfo(
        uid: '',
        id: '',
        daysPerWeek: 0,
        title: '',
      ),
    );
  }

  Workout copyWith({
    WorkoutInfo? info,
    WorkoutDays? workoutDays,
    bool? isActive,
    DateTime? startDate,
  }) {
    return Workout(
      info: info ?? this.info,
      workoutDays: workoutDays ?? this.workoutDays,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
    );
  }

  static String dateTimeToWorkoutLogId(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }
}

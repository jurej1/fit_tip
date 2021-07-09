part of 'add_workout_form_bloc.dart';

class AddWorkoutFormState extends Equatable {
  const AddWorkoutFormState({
    this.status = FormzStatus.pure,
    this.goal = const WorkoutGoalFormz.pure(),
    this.type = const WorkoutTypeFormz.pure(),
    this.duration = const WorkoutIntFormz.pure(),
    this.daysPerWeek = const WorkoutIntFormz.pure(),
    this.timePerWorkout = const WorkoutIntFormz.pure(),
    required this.startDate,
  });

  final FormzStatus status;
  final WorkoutGoalFormz goal;
  final WorkoutTypeFormz type;
  final WorkoutIntFormz duration;
  final WorkoutIntFormz daysPerWeek;
  final WorkoutIntFormz timePerWorkout;
  final WorkoutDateFormz startDate;

  factory AddWorkoutFormState.initial() {
    return AddWorkoutFormState(
      startDate: WorkoutDateFormz.pure(),
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      goal,
      type,
      duration,
      daysPerWeek,
      timePerWorkout,
      startDate,
    ];
  }

  AddWorkoutFormState copyWith({
    FormzStatus? status,
    WorkoutGoalFormz? goal,
    WorkoutTypeFormz? type,
    WorkoutIntFormz? duration,
    WorkoutIntFormz? daysPerWeek,
    WorkoutIntFormz? timePerWorkout,
    WorkoutDateFormz? startDate,
  }) {
    return AddWorkoutFormState(
      status: status ?? this.status,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      startDate: startDate ?? this.startDate,
    );
  }
}

part of 'add_workout_form_bloc.dart';

class AddWorkoutFormState {
  const AddWorkoutFormState({
    this.status = FormzStatus.pure,
    this.goal = const WorkoutGoalFormz.pure(),
    this.type = const WorkoutTypeFormz.pure(),
    this.duration = const WorkoutIntFormz.pure(),
    this.daysPerWeek = const WorkoutIntFormz.pure(),
    this.timePerWorkout = const WorkoutIntFormz.pure(),
    required this.startDate,
    this.workoutDays = const WorkoutDaysList.pure(),
  });

  final FormzStatus status;
  final WorkoutGoalFormz goal;
  final WorkoutTypeFormz type;
  final WorkoutIntFormz duration;
  final WorkoutIntFormz daysPerWeek;
  final WorkoutIntFormz timePerWorkout;
  final WorkoutDateFormz startDate;
  final WorkoutDaysList workoutDays;

  factory AddWorkoutFormState.initial() {
    return AddWorkoutFormState(
      startDate: WorkoutDateFormz.pure(),
    );
  }

  AddWorkoutFormState copyWith({
    FormzStatus? status,
    WorkoutGoalFormz? goal,
    WorkoutTypeFormz? type,
    WorkoutIntFormz? duration,
    WorkoutIntFormz? daysPerWeek,
    WorkoutIntFormz? timePerWorkout,
    WorkoutDateFormz? startDate,
    WorkoutDaysList? workoutDays,
  }) {
    return AddWorkoutFormState(
      status: status ?? this.status,
      goal: goal ?? this.goal,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      timePerWorkout: timePerWorkout ?? this.timePerWorkout,
      startDate: startDate ?? this.startDate,
      workoutDays: workoutDays ?? this.workoutDays,
    );
  }

  int get workoutDaysLenght => this.workoutDays.value.length;
  List<WorkoutDay> get workoutDaysItems => this.workoutDays.value;
  bool get noDaysPerWeek => this.daysPerWeek.pure || this.daysPerWeek.invalid || this.daysPerWeek.getIntValue() == 0;
}

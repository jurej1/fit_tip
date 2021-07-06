part of 'edit_excercise_daily_goal_bloc.dart';

class EditExcerciseDailyGoalState extends Equatable {
  const EditExcerciseDailyGoalState({
    this.status = FormzStatus.pure,
    this.caloriesBurnedPerDay = const ExcerciseCalories.pure(),
    this.workoutsPerWeek = const ExcerciseCalories.pure(),
    this.minutesPerWorkout = const ExcerciseCalories.pure(),
    this.minutesPerDay = const ExcerciseCalories.pure(),
    required this.date,
  });

  final FormzStatus status;
  final ExcerciseCalories caloriesBurnedPerDay;
  final ExcerciseCalories workoutsPerWeek;
  final ExcerciseCalories minutesPerWorkout;
  final ExcerciseCalories minutesPerDay;
  final DateTime date;

  @override
  List<Object> get props {
    return [
      status,
      caloriesBurnedPerDay,
      workoutsPerWeek,
      minutesPerWorkout,
      minutesPerDay,
      date,
    ];
  }

  ExcerciseDailyGoal goal() {
    return ExcerciseDailyGoal(
      date: this.date,
      caloriesBurnedPerDay: int.parse(caloriesBurnedPerDay.value),
      minutesPerDay: int.parse(minutesPerDay.value),
      minutesPerWorkout: int.parse(minutesPerWorkout.value),
      workoutsPerWeek: int.parse(workoutsPerWeek.value),
    );
  }

  EditExcerciseDailyGoalState copyWith({
    FormzStatus? status,
    ExcerciseCalories? caloriesBurnedPerDay,
    ExcerciseCalories? workoutsPerWeek,
    ExcerciseCalories? minutesPerWorkout,
    ExcerciseCalories? minutesPerDay,
    DateTime? date,
  }) {
    return EditExcerciseDailyGoalState(
      status: status ?? this.status,
      caloriesBurnedPerDay: caloriesBurnedPerDay ?? this.caloriesBurnedPerDay,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      minutesPerWorkout: minutesPerWorkout ?? this.minutesPerWorkout,
      minutesPerDay: minutesPerDay ?? this.minutesPerDay,
      date: date ?? this.date,
    );
  }
}

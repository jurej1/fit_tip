part of 'edit_calorie_daily_goal_bloc.dart';

class EditCalorieDailyGoalState extends Equatable {
  const EditCalorieDailyGoalState({
    this.status = FormzStatus.pure,
    this.calorieGoalConsumption = const CalorieGoalConsumption.pure(),
    required this.goal,
    this.fats = const AmountDetailConsumed.pure(),
    this.proteins = const AmountDetailConsumed.pure(),
    this.carbs = const AmountDetailConsumed.pure(),
  });

  final FormzStatus status;
  final CalorieGoalConsumption calorieGoalConsumption;
  final CalorieDailyGoal goal;
  final AmountDetailConsumed fats;
  final AmountDetailConsumed proteins;
  final AmountDetailConsumed carbs;

  @override
  List<Object?> get props {
    return [
      status,
      calorieGoalConsumption,
      goal,
      fats,
      proteins,
      carbs,
    ];
  }

  factory EditCalorieDailyGoalState.dirty(CalorieDailyGoal goal) {
    return EditCalorieDailyGoalState(
      calorieGoalConsumption: CalorieGoalConsumption.pure(goal.amount.toStringAsFixed(0)),
      carbs: AmountDetailConsumed.pure(goal.carbs != null ? goal.carbs.toString() : ''),
      fats: AmountDetailConsumed.pure(goal.fats != null ? goal.fats.toString() : ''),
      proteins: AmountDetailConsumed.pure(goal.proteins != null ? goal.proteins.toString() : ''),
      goal: goal,
    );
  }

  EditCalorieDailyGoalState copyWith({
    FormzStatus? status,
    CalorieGoalConsumption? calorieGoalConsumption,
    CalorieDailyGoal? goal,
    AmountDetailConsumed? fats,
    AmountDetailConsumed? proteins,
    AmountDetailConsumed? carbs,
  }) {
    return EditCalorieDailyGoalState(
      status: status ?? this.status,
      calorieGoalConsumption: calorieGoalConsumption ?? this.calorieGoalConsumption,
      goal: goal ?? this.goal,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
    );
  }
}


part of 'edit_calorie_daily_goal_bloc.dart';

class EditCalorieDailyGoalState extends Equatable {
  const EditCalorieDailyGoalState({
    this.status = FormzStatus.pure,
    this.calorieGoalConsumption = const CalorieGoalConsumption.pure(),
    required this.goal,
    this.fats = const AmountDetailConsumed.pure(),
    this.proteins = const AmountDetailConsumed.pure(),
    this.carbs = const AmountDetailConsumed.pure(),
     this.breakfast = const CalorieGoalConsumption.pure(),
     this.dinner = const CalorieGoalConsumption.pure(),
     this.lunch = const CalorieGoalConsumption.pure(),
     this.snack = const CalorieGoalConsumption.pure(),
  });

  final FormzStatus status;
  final CalorieGoalConsumption calorieGoalConsumption;
  final CalorieDailyGoal goal;
  final AmountDetailConsumed fats;
  final AmountDetailConsumed proteins;
  final AmountDetailConsumed carbs;
  final CalorieGoalConsumption breakfast;
  final CalorieGoalConsumption dinner;
  final CalorieGoalConsumption lunch;
  final CalorieGoalConsumption snack;

  @override
  List<Object> get props {
    return [
      status,
      calorieGoalConsumption,
      goal,
      fats,
      proteins,
      carbs,
      breakfast,
      dinner,
      lunch,
      snack,
    ];
  }

  factory EditCalorieDailyGoalState.dirty(CalorieDailyGoal goal) {
    return EditCalorieDailyGoalState(
      calorieGoalConsumption: CalorieGoalConsumption.pure(goal.amount.toStringAsFixed(0)),
      carbs: AmountDetailConsumed.pure(goal.carbs != null ? goal.carbs.toString() : ''),
      fats: AmountDetailConsumed.pure(goal.fats != null ? goal.fats.toString() : ''),
      proteins: AmountDetailConsumed.pure(goal.proteins != null ? goal.proteins.toString() : ''),
      goal: goal,
      breakfast: CalorieGoalConsumption.pure(goal.breakfast != null ? goal.breakfast!.toStringAsFixed(0): ''),
      dinner: CalorieGoalConsumption.pure(goal.dinner != null ? goal.dinner!.toStringAsFixed(0):''),
      lunch: CalorieGoalConsumption.pure(goal.lunch != null ? goal.lunch!.toStringAsFixed(0):''),
      snack: CalorieGoalConsumption.pure(goal.snack != null ? goal.snack!.toStringAsFixed(0):''),
      
    );
  }

  EditCalorieDailyGoalState copyWith({
    FormzStatus? status,
    CalorieGoalConsumption? calorieGoalConsumption,
    CalorieDailyGoal? goal,
    AmountDetailConsumed? fats,
    AmountDetailConsumed? proteins,
    AmountDetailConsumed? carbs,
    CalorieGoalConsumption? breakfast,
    CalorieGoalConsumption? dinner,
    CalorieGoalConsumption? lunch,
    CalorieGoalConsumption? snack,
  }) {
    return EditCalorieDailyGoalState(
      status: status ?? this.status,
      calorieGoalConsumption: calorieGoalConsumption ?? this.calorieGoalConsumption,
      goal: goal ?? this.goal,
      fats: fats ?? this.fats,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      breakfast: breakfast ?? this.breakfast,
      dinner: dinner ?? this.dinner,
      lunch: lunch ?? this.lunch,
      snack: snack ?? this.snack,
    );
  }
}

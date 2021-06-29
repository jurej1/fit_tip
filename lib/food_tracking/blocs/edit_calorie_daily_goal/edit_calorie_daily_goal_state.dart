part of 'edit_calorie_daily_goal_bloc.dart';

class EditCalorieDailyGoalState extends Equatable {
  const EditCalorieDailyGoalState({
    this.status = FormzStatus.pure,
    required this.calorieDailyConsumptionGoal,
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
  final CalorieDailyConsumptionGoal calorieDailyConsumptionGoal;
  final CalorieDailyGoal goal;
  final AmountDetailConsumed fats;
  final AmountDetailConsumed proteins;
  final AmountDetailConsumed carbs;
  final CalorieGoalConsumption breakfast;
  final CalorieGoalConsumption dinner;
  final CalorieGoalConsumption lunch;
  final CalorieGoalConsumption snack;

  int getMealsCalorieAmount() {
    int dinnerValue = int.tryParse(dinner.value) ?? 0;
    int breakfastValue = int.tryParse(breakfast.value) ?? 0;
    int lunchValue = int.tryParse(lunch.value) ?? 0;
    int snackValue = int.tryParse(snack.value) ?? 0;

    return snackValue + dinnerValue + breakfastValue + lunchValue;
  }

  @override
  List<Object> get props {
    return [
      status,
      calorieDailyConsumptionGoal,
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
      calorieDailyConsumptionGoal: CalorieDailyConsumptionGoal.pure(value: goal.amount.toStringAsFixed(0)),
      carbs: AmountDetailConsumed.pure(
        goal.carbs != null ? goal.carbs.toString() : '',
      ),
      fats: AmountDetailConsumed.pure(
        goal.fats != null ? goal.fats.toString() : '',
      ),
      proteins: AmountDetailConsumed.pure(
        goal.proteins != null ? goal.proteins.toString() : '',
      ),
      goal: goal,
      breakfast: CalorieGoalConsumption.pure(
        goal.breakfast != null ? goal.breakfast!.toStringAsFixed(0) : '',
      ),
      dinner: CalorieGoalConsumption.pure(
        goal.dinner != null ? goal.dinner!.toStringAsFixed(0) : '',
      ),
      lunch: CalorieGoalConsumption.pure(
        goal.lunch != null ? goal.lunch!.toStringAsFixed(0) : '',
      ),
      snack: CalorieGoalConsumption.pure(
        goal.snack != null ? goal.snack!.toStringAsFixed(0) : '',
      ),
    );
  }

  EditCalorieDailyGoalState copyWith({
    FormzStatus? status,
    CalorieDailyConsumptionGoal? calorieGoalConsumption,
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
      calorieDailyConsumptionGoal: calorieGoalConsumption ?? this.calorieDailyConsumptionGoal,
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

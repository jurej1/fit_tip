part of 'edit_calorie_daily_goal_bloc.dart';

class EditCalorieDailyGoalState extends Equatable {
  const EditCalorieDailyGoalState({
    this.status = FormzStatus.pure,
    this.calorieGoalConsumption = const CalorieGoalConsumption.pure(),
    this.goal,
  });

  final FormzStatus status;
  final CalorieGoalConsumption calorieGoalConsumption;
  final CalorieDailyGoal? goal;

  @override
  List<Object?> get props => [status, calorieGoalConsumption, goal];

  EditCalorieDailyGoalState copyWith({
    FormzStatus? status,
    CalorieGoalConsumption? calorieGoalConsumption,
    CalorieDailyGoal? goal,
  }) {
    return EditCalorieDailyGoalState(
      status: status ?? this.status,
      calorieGoalConsumption: calorieGoalConsumption ?? this.calorieGoalConsumption,
      goal: goal ?? this.goal,
    );
  }
}

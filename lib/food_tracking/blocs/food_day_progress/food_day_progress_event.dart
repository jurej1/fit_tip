part of 'food_day_progress_bloc.dart';

abstract class FoodDayProgressEvent extends Equatable {
  const FoodDayProgressEvent();

  @override
  List<Object?> get props => [];
}

class FoodDayProgressCalorieGoalUpdated extends FoodDayProgressEvent {
  final CalorieDailyGoal calorieGoal;

  FoodDayProgressCalorieGoalUpdated({
    required this.calorieGoal,
  });

  @override
  List<Object?> get props => [calorieGoal];
}

class FoodDayProgressDailyLogsUpdated extends FoodDayProgressEvent {
  final MealDay mealDay;

  FoodDayProgressDailyLogsUpdated({
    required this.mealDay,
  });

  @override
  List<Object?> get props => [mealDay];
}

class FoodDayProgressSelectedViewUpdated extends FoodDayProgressEvent {
  final int index;

  const FoodDayProgressSelectedViewUpdated(
    this.index,
  );

  @override
  List<Object?> get props => [index];
}

class FoodDayProgressErroOcurred extends FoodDayProgressEvent {}

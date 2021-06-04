part of 'food_day_progress_bloc.dart';

abstract class FoodDayProgressEvent extends Equatable {
  const FoodDayProgressEvent();

  @override
  List<Object?> get props => [];
}

class FoodDayProgressCalorieGoalUpdated extends FoodDayProgressEvent {
  final double? calorieGoal;

  FoodDayProgressCalorieGoalUpdated({
    this.calorieGoal,
  });

  @override
  List<Object?> get props => [calorieGoal];
}

class FoodDayProgressDailyLogsUpdated extends FoodDayProgressEvent {
  final double? totalConsumption;

  FoodDayProgressDailyLogsUpdated({
    this.totalConsumption,
  });

  @override
  List<Object?> get props => [totalConsumption];
}

class FoodDayProgressErroOcurred extends FoodDayProgressEvent {}

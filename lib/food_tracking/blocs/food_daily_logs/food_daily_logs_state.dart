part of 'food_daily_logs_bloc.dart';

abstract class FoodDailyLogsState {
  const FoodDailyLogsState();
}

class FoodDailyLogsLoading extends FoodDailyLogsState {}

class FoodDailyLogsLoadSuccess extends FoodDailyLogsState {
  final MealDay mealDay;

  const FoodDailyLogsLoadSuccess({required this.mealDay});
}

class FoodDailyLogsFailure extends FoodDailyLogsState {
  final String? errorMsg;

  const FoodDailyLogsFailure({this.errorMsg});
}

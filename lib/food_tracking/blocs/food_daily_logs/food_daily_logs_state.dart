part of 'food_daily_logs_bloc.dart';

abstract class FoodDailyLogsState extends Equatable {
  const FoodDailyLogsState();

  @override
  List<Object?> get props => [];
}

class FoodDailyLogsLoading extends FoodDailyLogsState {}

class FoodDailyLogsLoadSuccess extends FoodDailyLogsState {
  final MealDay? mealDay;

  const FoodDailyLogsLoadSuccess({
    this.mealDay,
  });

  @override
  List<Object?> get props => [mealDay];
}

class FoodDailyLogsFailure extends FoodDailyLogsState {
  final String? errorMsg;

  const FoodDailyLogsFailure({this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}

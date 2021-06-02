part of 'food_daily_logs_bloc.dart';

abstract class FoodDailyLogsState extends Equatable {
  const FoodDailyLogsState();

  @override
  List<Object?> get props => [];
}

class FoodDailyLogsLoading extends FoodDailyLogsState {}

class FoodDailyLogLoadSuccess extends FoodDailyLogsState {
  final MealDay? mealDay;

  const FoodDailyLogLoadSuccess({
    this.mealDay,
  });

  @override
  List<Object?> get props => [mealDay];
}

class FoodDailyLogFailure extends FoodDailyLogsState {
  final String? errorMsg;

  const FoodDailyLogFailure({this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}

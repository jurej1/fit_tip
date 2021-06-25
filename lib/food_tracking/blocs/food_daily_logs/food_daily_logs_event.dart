part of 'food_daily_logs_bloc.dart';

abstract class FoodDailyLogsEvent extends Equatable {
  const FoodDailyLogsEvent();

  @override
  List<Object?> get props => [];
}

class FoodDailyLogsFocusedDateUpdated extends FoodDailyLogsEvent {
  final DateTime? date;

  const FoodDailyLogsFocusedDateUpdated(this.date);

  @override
  List<Object?> get props => [date];
}

class FoodDailyLogsLogAdded extends FoodDailyLogsEvent {
  final FoodItem? foodItem;

  const FoodDailyLogsLogAdded({this.foodItem});
  @override
  List<Object?> get props => [foodItem];
}

class FoodDailyLogsLogRemoved extends FoodDailyLogsEvent {
  final FoodItem? foodItem;

  FoodDailyLogsLogRemoved({this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

class FoodDailyLogsLogUpdated extends FoodDailyLogsEvent {
  final FoodItem? foodItem;

  FoodDailyLogsLogUpdated({this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

part of 'food_day_progress_bloc.dart';

abstract class FoodDayProgressState extends Equatable {
  const FoodDayProgressState();

  @override
  List<Object> get props => [];
}

class FoodDayProgressLoading extends FoodDayProgressState {}

class FoodDayProgressLoadSuccess extends FoodDayProgressState {
  final double calorieGoal;
  final double calorieConsume;

  final int fatsGoal;
  final int fatsConsumed;

  final int carbsGoal;
  final int carbsConsumed;

  final int proteinGoal;
  final int proteinConsumed;

  FoodDayProgressLoadSuccess({
    this.calorieGoal = 0,
    this.calorieConsume = 0,
    this.carbsConsumed = 0,
    this.carbsGoal = 0,
    this.fatsConsumed = 0,
    this.fatsGoal = 0,
    this.proteinConsumed = 0,
    this.proteinGoal = 0,
  });

  @override
  List<Object> get props => [calorieGoal, calorieConsume];
}

class FoodDayProgressFailure extends FoodDayProgressState {}

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

  FoodDayProgressLoadSuccess({
    this.calorieGoal = 0,
    this.calorieConsume = 0,
  });

  @override
  List<Object> get props => [calorieGoal, calorieConsume];
}

class FoodDayProgressFailure extends FoodDayProgressState {}

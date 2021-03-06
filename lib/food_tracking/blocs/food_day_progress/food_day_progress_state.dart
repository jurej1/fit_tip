part of 'food_day_progress_bloc.dart';

enum FoodDayProgressCarouselView { calories, proteins, carbs, fats }

abstract class FoodDayProgressState extends Equatable {
  const FoodDayProgressState();

  factory FoodDayProgressState.initial({
    required CalorieDailyGoalBloc calGoalBloc,
    required FoodDailyLogsBloc dailyLogsBloc,
  }) {
    final goalState = calGoalBloc.state;
    final logsState = dailyLogsBloc.state;

    if (goalState is CalorieDailyGoalLoadSuccess && logsState is FoodDailyLogsLoadSuccess) {
      return FoodDayProgressLoadSuccess(
        calorieConsume: logsState.mealDay.totalCalories,
        calorieGoal: goalState.calorieDailyGoal.amount,
        carbsGoal: goalState.calorieDailyGoal.carbs ?? 0,
        carbsConsumed: logsState.mealDay.getMacroAmount(Macronutrient.carbs),
        fatsConsumed: logsState.mealDay.getMacroAmount(Macronutrient.fat),
        fatsGoal: goalState.calorieDailyGoal.fats ?? 0,
        proteinConsumed: logsState.mealDay.getMacroAmount(Macronutrient.protein),
        proteinGoal: goalState.calorieDailyGoal.proteins ?? 0,
      );
    }

    return FoodDayProgressLoading();
  }

  @override
  List<Object> get props => [];
}

class FoodDayProgressLoading extends FoodDayProgressState {}

class FoodDayProgressLoadSuccess extends FoodDayProgressState {
  final int calorieGoal;
  final int calorieConsume;

  final int fatsGoal;
  final int fatsConsumed;

  final int carbsGoal;
  final int carbsConsumed;

  final int proteinGoal;
  final int proteinConsumed;

  final FoodDayProgressCarouselView selectedView;

  FoodDayProgressLoadSuccess({
    this.calorieGoal = 0,
    this.calorieConsume = 0,
    this.fatsGoal = 0,
    this.fatsConsumed = 0,
    this.carbsGoal = 0,
    this.carbsConsumed = 0,
    this.proteinGoal = 0,
    this.proteinConsumed = 0,
    FoodDayProgressCarouselView? selectedView,
  }) : this.selectedView = selectedView ?? FoodDayProgressCarouselView.calories;

  @override
  List<Object> get props => [
        calorieGoal,
        calorieConsume,
        fatsGoal,
        fatsConsumed,
        carbsGoal,
        carbsConsumed,
        proteinGoal,
        proteinConsumed,
        selectedView,
      ];

  FoodDayProgressLoadSuccess copyWith({
    int? calorieGoal,
    int? calorieConsume,
    int? fatsGoal,
    int? fatsConsumed,
    int? carbsGoal,
    int? carbsConsumed,
    int? proteinGoal,
    int? proteinConsumed,
    FoodDayProgressCarouselView? selectedView,
  }) {
    return FoodDayProgressLoadSuccess(
      calorieGoal: calorieGoal ?? this.calorieGoal,
      calorieConsume: calorieConsume ?? this.calorieConsume,
      fatsGoal: fatsGoal ?? this.fatsGoal,
      fatsConsumed: fatsConsumed ?? this.fatsConsumed,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      carbsConsumed: carbsConsumed ?? this.carbsConsumed,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      proteinConsumed: proteinConsumed ?? this.proteinConsumed,
      selectedView: selectedView ?? this.selectedView,
    );
  }

  int getPrimaryValueBasedOnView() {
    if (selectedView == FoodDayProgressCarouselView.calories) {
      return this.calorieConsume;
    } else if (selectedView == FoodDayProgressCarouselView.carbs) {
      return carbsConsumed;
    } else if (selectedView == FoodDayProgressCarouselView.fats) {
      return fatsConsumed;
    } else if (selectedView == FoodDayProgressCarouselView.proteins) {
      return proteinConsumed;
    }
    return 0;
  }

  int getMaxValueBasedOnView() {
    if (selectedView == FoodDayProgressCarouselView.calories) {
      return this.calorieGoal;
    } else if (selectedView == FoodDayProgressCarouselView.carbs) {
      return this.carbsGoal;
    } else if (selectedView == FoodDayProgressCarouselView.fats) {
      return this.fatsGoal;
    } else if (selectedView == FoodDayProgressCarouselView.proteins) {
      return this.proteinGoal;
    }

    return 0;
  }

  Color getPrimaryColorBasedOnView() {
    if (selectedView == FoodDayProgressCarouselView.calories) {
      return Colors.blue;
    } else if (selectedView == FoodDayProgressCarouselView.carbs) {
      return Colors.green;
    } else if (selectedView == FoodDayProgressCarouselView.fats) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  Color getSecondaryColorBasedOnView() {
    return getPrimaryColorBasedOnView().withOpacity(0.4);
  }

  double getSelectedViewIndex() {
    return FoodDayProgressCarouselView.values.indexOf(selectedView).toDouble();
  }
}

class FoodDayProgressFailure extends FoodDayProgressState {}

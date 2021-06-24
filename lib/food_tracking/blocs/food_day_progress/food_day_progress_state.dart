part of 'food_day_progress_bloc.dart';

enum FoodDayProgressCarouselView { calories, proteins, carbs, fats }

abstract class FoodDayProgressState extends Equatable {
  const FoodDayProgressState();

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
  FoodDayProgressCarouselView? previousView;

  FoodDayProgressLoadSuccess({
    this.calorieGoal = 0,
    this.calorieConsume = 0,
    this.fatsGoal = 0,
    this.fatsConsumed = 0,
    this.carbsGoal = 0,
    this.carbsConsumed = 0,
    this.proteinGoal = 0,
    this.proteinConsumed = 0,
    this.selectedView = FoodDayProgressCarouselView.calories,
    this.previousView,
  });

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
    FoodDayProgressCarouselView? previousView,
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
      previousView: previousView ?? this.previousView,
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

  int getPrimaryValueBasedOnPreviousView() {
    if (previousView == FoodDayProgressCarouselView.calories) {
      return this.calorieConsume;
    } else if (previousView == FoodDayProgressCarouselView.carbs) {
      return carbsConsumed;
    } else if (previousView == FoodDayProgressCarouselView.fats) {
      return fatsConsumed;
    } else if (previousView == FoodDayProgressCarouselView.proteins) {
      return proteinConsumed;
    }
    return 0;
  }

  int getMaxValueBasedOnPreviousView() {
    if (previousView == FoodDayProgressCarouselView.calories) {
      return this.calorieGoal;
    } else if (previousView == FoodDayProgressCarouselView.carbs) {
      return this.carbsGoal;
    } else if (previousView == FoodDayProgressCarouselView.fats) {
      return this.fatsGoal;
    } else if (previousView == FoodDayProgressCarouselView.proteins) {
      return this.proteinGoal;
    }

    return 0;
  }
}

class FoodDayProgressFailure extends FoodDayProgressState {}

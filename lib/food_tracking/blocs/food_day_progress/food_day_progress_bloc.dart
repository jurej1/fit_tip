import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:food_repository/food_repository.dart';

part 'food_day_progress_event.dart';
part 'food_day_progress_state.dart';

class FoodDayProgressBloc extends Bloc<FoodDayProgressEvent, FoodDayProgressState> {
  FoodDayProgressBloc({
    required CalorieDailyGoalBloc calorieDailyGoalBloc,
    required FoodDailyLogsBloc foodDailyLogsBloc,
  })   : _calorieDailyGoalBloc = calorieDailyGoalBloc,
        _foodDailyLogsBloc = foodDailyLogsBloc,
        super(FoodDayProgressLoading()) {
    final calState = _calorieDailyGoalBloc.state;

    if (calState is CalorieDailyGoalLoadSuccess) {
      add(FoodDayProgressCalorieGoalUpdated(calorieGoal: calState.calorieDailyGoal));
    } else if (calState is CalorieDailyGoalFailure) {
      add(FoodDayProgressErroOcurred());
    }

    final logsState = _foodDailyLogsBloc.state;

    if (logsState is FoodDailyLogsLoadSuccess) {
      add(FoodDayProgressDailyLogsUpdated(mealDay: logsState.mealDay));
    } else if (logsState is FoodDailyLogsFailure) {
      add(FoodDayProgressErroOcurred());
    }
    _logsSubscription = foodDailyLogsBloc.stream.listen((logState) {
      if (logState is FoodDailyLogsLoadSuccess) {
        add(FoodDayProgressDailyLogsUpdated(mealDay: logState.mealDay));
      } else if (logState is FoodDailyLogsFailure) {
        add(FoodDayProgressErroOcurred());
      }
    });

    _goalSubscription = calorieDailyGoalBloc.stream.listen((calState) {
      if (calState is CalorieDailyGoalLoadSuccess) {
        add(FoodDayProgressCalorieGoalUpdated(calorieGoal: calState.calorieDailyGoal));
      } else if (calState is CalorieDailyGoalFailure) {
        add(FoodDayProgressErroOcurred());
      }
    });
  }

  final CalorieDailyGoalBloc _calorieDailyGoalBloc;
  final FoodDailyLogsBloc _foodDailyLogsBloc;
  late final StreamSubscription _logsSubscription;
  late final StreamSubscription _goalSubscription;

  @override
  Stream<FoodDayProgressState> mapEventToState(
    FoodDayProgressEvent event,
  ) async* {
    if (event is FoodDayProgressCalorieGoalUpdated) {
      yield* _mapGoalUpdatedToState(event);
    } else if (event is FoodDayProgressDailyLogsUpdated) {
      yield* _mapLogsUpdatedToState(event);
    } else if (event is FoodDayProgressSelectedViewUpdated) {
      yield* _mapViewUpdatedToState(event);
    } else if (event is FoodDayProgressErroOcurred) {
      yield FoodDayProgressFailure();
    }
  }

  Stream<FoodDayProgressState> _mapGoalUpdatedToState(FoodDayProgressCalorieGoalUpdated event) async* {
    if (_foodDailyLogsBloc.state is FoodDailyLogsLoadSuccess) {
      final logState = (_foodDailyLogsBloc.state as FoodDailyLogsLoadSuccess);

      yield FoodDayProgressLoadSuccess(
        calorieConsume: logState.mealDay.totalCalories,
        calorieGoal: event.calorieGoal.amount,
        carbsConsumed: logState.mealDay.getMacroAmount(Macronutrient.carbs),
        carbsGoal: event.calorieGoal.carbs ?? 0,
        fatsConsumed: logState.mealDay.getMacroAmount(Macronutrient.fat),
        fatsGoal: event.calorieGoal.fats ?? 0,
        proteinConsumed: logState.mealDay.getMacroAmount(Macronutrient.protein),
        proteinGoal: event.calorieGoal.proteins ?? 0,
      );
    }
  }

  Stream<FoodDayProgressState> _mapLogsUpdatedToState(FoodDayProgressDailyLogsUpdated event) async* {
    if (_calorieDailyGoalBloc.state is CalorieDailyGoalLoadSuccess) {
      final calState = _calorieDailyGoalBloc.state as CalorieDailyGoalLoadSuccess;

      yield FoodDayProgressLoadSuccess(
        calorieConsume: event.mealDay.totalCalories,
        calorieGoal: calState.calorieDailyGoal.amount,
        carbsConsumed: event.mealDay.getMacroAmount(Macronutrient.carbs),
        carbsGoal: calState.calorieDailyGoal.carbs ?? 0,
        fatsConsumed: event.mealDay.getMacroAmount(Macronutrient.fat),
        fatsGoal: calState.calorieDailyGoal.fats ?? 0,
        proteinConsumed: event.mealDay.getMacroAmount(Macronutrient.protein),
        proteinGoal: calState.calorieDailyGoal.proteins ?? 0,
      );
    }
  }

  Stream<FoodDayProgressState> _mapViewUpdatedToState(FoodDayProgressSelectedViewUpdated event) async* {
    if (state is FoodDayProgressLoadSuccess) {
      yield (state as FoodDayProgressLoadSuccess).copyWith(
        selectedView: FoodDayProgressCarouselView.values[event.index],
      );
    }
  }

  @override
  Future<void> close() {
    _logsSubscription.cancel();
    _goalSubscription.cancel();
    return super.close();
  }
}

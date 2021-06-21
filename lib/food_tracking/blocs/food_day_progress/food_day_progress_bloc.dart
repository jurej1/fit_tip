import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';

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
      add(FoodDayProgressCalorieGoalUpdated(calorieGoal: calState.calorieDailyGoal?.amount));
    } else if (calState is CalorieDailyGoalFailure) {
      add(FoodDayProgressErroOcurred());
    }

    final logsState = _foodDailyLogsBloc.state;

    if (logsState is FoodDailyLogsLoadSuccess) {
      add(FoodDayProgressDailyLogsUpdated(totalConsumption: logsState.mealDay.totalCalories));
    } else if (logsState is FoodDailyLogsFailure) {
      add(FoodDayProgressErroOcurred());
    }
    _logsSubscription = foodDailyLogsBloc.stream.listen((logState) {
      if (logState is FoodDailyLogsLoadSuccess) {
        add(FoodDayProgressDailyLogsUpdated(totalConsumption: logState.mealDay.totalCalories));
      } else if (logState is FoodDailyLogsFailure) {
        add(FoodDayProgressErroOcurred());
      }
    });

    _goalSubscription = calorieDailyGoalBloc.stream.listen((calState) {
      if (calState is CalorieDailyGoalLoadSuccess) {
        add(FoodDayProgressCalorieGoalUpdated(calorieGoal: calState.calorieDailyGoal?.amount));
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
    } else if (event is FoodDayProgressErroOcurred) {
      yield FoodDayProgressFailure();
    }
  }

  Stream<FoodDayProgressState> _mapGoalUpdatedToState(FoodDayProgressCalorieGoalUpdated event) async* {
    if (event.calorieGoal != null && _foodDailyLogsBloc.state is FoodDailyLogsLoadSuccess) {
      final logState = (_foodDailyLogsBloc.state as FoodDailyLogsLoadSuccess);

      yield FoodDayProgressLoadSuccess(
        calorieConsume: logState.mealDay.totalCalories,
        calorieGoal: event.calorieGoal ?? 0,
      );
    }
  }

  Stream<FoodDayProgressState> _mapLogsUpdatedToState(FoodDayProgressDailyLogsUpdated event) async* {
    if (event.totalConsumption != null && _calorieDailyGoalBloc.state is CalorieDailyGoalLoadSuccess) {
      final calState = _calorieDailyGoalBloc.state as CalorieDailyGoalLoadSuccess;

      yield FoodDayProgressLoadSuccess(
        calorieConsume: event.totalConsumption!,
        calorieGoal: calState.calorieDailyGoal?.amount ?? 0,
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

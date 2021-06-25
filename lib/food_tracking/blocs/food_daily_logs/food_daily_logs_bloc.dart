import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/blocs.dart';
import 'package:food_repository/food_repository.dart';

part 'food_daily_logs_event.dart';
part 'food_daily_logs_state.dart';

class FoodDailyLogsBloc extends Bloc<FoodDailyLogsEvent, FoodDailyLogsState> {
  FoodDailyLogsBloc({
    required FoodRepository foodRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _foodRepository = foodRepository,
        _authenticationBloc = authenticationBloc,
        super(FoodDailyLogsLoading());

  final FoodRepository _foodRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<FoodDailyLogsState> mapEventToState(
    FoodDailyLogsEvent event,
  ) async* {
    if (event is FoodDailyLogsFocusedDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is FoodDailyLogsLogAdded) {
      yield* _mapLogAddedToState(event);
    } else if (event is FoodDailyLogsLogRemoved) {
      yield* _mapLogDeletedToState(event);
    } else if (event is FoodDailyLogsLogUpdated) {
      yield* _mapLogUpdatedToState(event);
    }
  }

  Stream<FoodDailyLogsState> _mapLogAddedToState(FoodDailyLogsLogAdded event) async* {
    if (_isAuth && state is FoodDailyLogsLoadSuccess && event.foodItem != null) {
      MealDay mealDay = (state as FoodDailyLogsLoadSuccess).mealDay;

      final MealType type = event.foodItem!.mealType;
      final item = event.foodItem!;

      mealDay = mealDay.copyWith(
        breakfast: type == MealType.breakfast ? _addFoodItemToMeal(item, mealDay.breakfast) : null,
        dinner: type == MealType.dinner ? _addFoodItemToMeal(item, mealDay.dinner) : null,
        lunch: type == MealType.lunch ? _addFoodItemToMeal(item, mealDay.lunch) : null,
        snacks: type == MealType.snack ? _addFoodItemToMeal(item, mealDay.snacks) : null,
      );

      yield FoodDailyLogsLoadSuccess(mealDay: mealDay);
    }
  }

  Stream<FoodDailyLogsState> _mapLogDeletedToState(FoodDailyLogsLogRemoved event) async* {
    if (_isAuth && state is FoodDailyLogsLoadSuccess && event.foodItem != null) {
      MealDay mealDay = (state as FoodDailyLogsLoadSuccess).mealDay;

      final item = event.foodItem!;
      final MealType type = item.mealType;

      mealDay = mealDay.copyWith(
        breakfast: type == MealType.breakfast ? _removeFoodItemFromMeal(item, mealDay.breakfast) : null,
        dinner: type == MealType.dinner ? _removeFoodItemFromMeal(item, mealDay.dinner) : null,
        lunch: type == MealType.lunch ? _removeFoodItemFromMeal(item, mealDay.lunch) : null,
        snacks: type == MealType.snack ? _removeFoodItemFromMeal(item, mealDay.snacks) : null,
      );

      yield FoodDailyLogsLoadSuccess(mealDay: mealDay);
    }
  }

  Stream<FoodDailyLogsState> _mapLogUpdatedToState(FoodDailyLogsLogUpdated event) async* {
    if (_isAuth && state is FoodDailyLogsLoadSuccess && event.foodItem != null) {
      MealDay mealDay = (state as FoodDailyLogsLoadSuccess).mealDay;

      final item = event.foodItem!;
      final MealType type = item.mealType;

      List<FoodItem> updatedList = mealDay.getAllFoodItems().map((e) {
        if (e.id == event.foodItem!.id) {
          return event.foodItem!;
        }

        return e;
      }).toList();

      MealDay newMealDay = mealDay.copyWith(
        breakfast: _updateFoodItemInMeal(updatedList, mealDay.breakfast),
        dinner: _updateFoodItemInMeal(updatedList, mealDay.dinner),
        lunch: _updateFoodItemInMeal(updatedList, mealDay.lunch),
        snacks: _updateFoodItemInMeal(updatedList, mealDay.snacks),
      );

      yield FoodDailyLogsLoadSuccess(mealDay: newMealDay);
    }
  }

  Stream<FoodDailyLogsState> _mapDateUpdatedToState(FoodDailyLogsFocusedDateUpdated event) async* {
    if (_isAuth && event.date != null) {
      yield FoodDailyLogsLoading();

      try {
        MealDay? mealDay = await _foodRepository.getMealDayForSpecificDay(_user!.id!, event.date!);

        yield FoodDailyLogsLoadSuccess(mealDay: mealDay == null ? MealDay() : mealDay);
      } on Exception catch (e) {
        print('error ' + e.toString());

        yield FoodDailyLogsFailure(errorMsg: e.toString());
      }
    }
  }

  Meal _addFoodItemToMeal(
    FoodItem item,
    Meal? meal,
  ) {
    if (meal == null) {
      return Meal(
        foods: [item],
        type: item.mealType,
        date: item.dateAdded,
      );
    } else {
      final List<FoodItem> foods = meal.foods..add(item);

      return meal.copyWith(
        foods: foods,
      );
    }
  }

  Meal? _removeFoodItemFromMeal(FoodItem item, Meal? meal) {
    if (meal == null) {
      return null;
    } else {
      final List<FoodItem> foods = meal.foods..removeWhere((element) => element.id == item.id);
      return meal.copyWith(foods: foods);
    }
  }

  Meal? _updateFoodItemInMeal(List<FoodItem> items, Meal? meal) {
    if (meal == null) return null;

    return meal.copyWith(
      foods: items.where((e) => e.mealType == meal.type).toList(),
    );
  }
}

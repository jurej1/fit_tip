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
    } else if (event is FoodDailyLogsLogAdded) {
      yield* _mapLogAddedToState(event);
    } else if (event is FoodDailyLogsLogRemoved) {
      yield* _mapLogDeletedToState(event);
    } else if (event is FoodDailyLogsLogUpdated) {
      yield* _mapLogUpdatedToState(event);
    }
  }

  Stream<FoodDailyLogsState> _mapLogAddedToState(FoodDailyLogsLogAdded event) async* {
    if (_isAuth && state is FoodDailyLogLoadSuccess && event.foodItem != null) {
      MealDay? mealDay = (state as FoodDailyLogLoadSuccess).mealDay;
      if (mealDay != null) {
        final MealType type = event.foodItem!.mealType;
        final item = event.foodItem!;

        mealDay = mealDay.copyWith(
          breakfast: type == MealType.breakfast ? _addFoodItemToMeal(item, mealDay.breakfast) : null,
          dinner: type == MealType.dinner ? _addFoodItemToMeal(item, mealDay.dinner) : null,
          lunch: type == MealType.lunch ? _addFoodItemToMeal(item, mealDay.lunch) : null,
          snacks: type == MealType.snack ? _addFoodItemToMeal(item, mealDay.snacks) : null,
        );

        yield FoodDailyLogLoadSuccess(mealDay: mealDay);
      }
    }
  }

  Stream<FoodDailyLogsState> _mapLogDeletedToState(FoodDailyLogsLogRemoved event) async* {
    if (_isAuth && state is FoodDailyLogLoadSuccess && event.foodItem != null) {
      MealDay? mealDay = (state as FoodDailyLogLoadSuccess).mealDay;

      if (mealDay != null) {
        final item = event.foodItem!;
        final MealType type = item.mealType;

        mealDay = mealDay.copyWith(
          breakfast: type == MealType.breakfast ? _removeFoodItemFromMeal(item, mealDay.breakfast) : null,
          dinner: type == MealType.dinner ? _removeFoodItemFromMeal(item, mealDay.dinner) : null,
          lunch: type == MealType.lunch ? _removeFoodItemFromMeal(item, mealDay.lunch) : null,
          snacks: type == MealType.snack ? _removeFoodItemFromMeal(item, mealDay.snacks) : null,
        );

        yield FoodDailyLogLoadSuccess(mealDay: mealDay);
      }
    }
  }

  Stream<FoodDailyLogsState> _mapLogUpdatedToState(FoodDailyLogsLogUpdated event) async* {
    if (_isAuth && state is FoodDailyLogLoadSuccess && event.foodItem != null) {
      MealDay? mealDay = (state as FoodDailyLogLoadSuccess).mealDay;

      if (mealDay != null) {
        final item = event.foodItem!;
        final MealType type = item.mealType;

        mealDay = mealDay.copyWith(
          breakfast: type == MealType.breakfast ? _updateFoodItemInMeal(item, mealDay.breakfast) : null,
          dinner: type == MealType.dinner ? _updateFoodItemInMeal(item, mealDay.dinner) : null,
          lunch: type == MealType.lunch ? _updateFoodItemInMeal(item, mealDay.lunch) : null,
          snacks: type == MealType.snack ? _updateFoodItemInMeal(item, mealDay.snacks) : null,
        );

        yield FoodDailyLogLoadSuccess(mealDay: mealDay);
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

  Meal? _updateFoodItemInMeal(FoodItem item, Meal? meal) {
    if (meal == null) {
      return null;
    } else {
      List<FoodItem> foods = meal.foods.map((e) {
        if (e.id == item.id) {
          return item;
        }
        return e;
      }).toList();

      return meal.copyWith(foods: foods);
    }
  }
}

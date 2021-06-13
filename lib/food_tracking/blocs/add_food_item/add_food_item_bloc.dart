import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'add_food_item_event.dart';
part 'add_food_item_state.dart';

class AddFoodItemBloc extends Bloc<AddFoodItemEvent, AddFoodItemState> {
  AddFoodItemBloc({
    required FoodRepository foodRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _foodRepository = foodRepository,
        _authenticationBloc = authenticationBloc,
        super(AddFoodItemState.pure());

  final FoodRepository _foodRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<AddFoodItemState> mapEventToState(
    AddFoodItemEvent event,
  ) async* {
    if (event is AddFoodItemDateChanged) {
      yield _mapDateChangedToState(event);
    } else if (event is AddFoodItemTimeConsumed) {
      yield _mapTimeChangedToState(event);
    } else if (event is AddFoodItemNameChanged) {
      yield _mapNameChangedToState(event);
    } else if (event is AddFoodItemAmountChanged) {
      yield _mapCalorieAmountToState(event);
    } else if (event is AddFoodItemMealTypeChanged) {
      yield state.copyWith(type: event.value);
    } else if (event is AddFoodItemCalorieChanged) {
      yield _mapCalorieChangedToState(event);
    } else if (event is AddFoodItemSubmitForm) {
      yield* _mapSubmitFormToState();
    } else if (event is AddFoodItemCarbsChanged) {
      yield _mapCarbsChangedToState(event);
    } else if (event is AddFoodItemProteinChanged) {
      yield _mapProteinChangedToState(event);
    } else if (event is AddFoodItemFatsChanged) {
      yield _mapFatChangedToState(event);
    }
  }

  AddFoodItemState _mapDateChangedToState(AddFoodItemDateChanged event) {
    final date = DateConsumed.dirty(event.date);

    return state.copyWith(
      dateConsumed: date,
      status: Formz.validate(
        [
          date,
          state.timeConsumed,
          state.foodName,
          state.calorieConsumed,
          state.amountConsumed,
          state.carbs,
          state.proteins,
          state.fats,
        ],
      ),
    );
  }

  AddFoodItemState _mapTimeChangedToState(AddFoodItemTimeConsumed event) {
    final time = TimeConsumed.dirty(event.timeOfDay);

    return state.copyWith(
      timeConsumed: time,
      status: Formz.validate([
        state.dateConsumed,
        time,
        state.foodName,
        state.calorieConsumed,
        state.amountConsumed,
        state.carbs,
        state.proteins,
        state.fats,
      ]),
    );
  }

  AddFoodItemState _mapNameChangedToState(AddFoodItemNameChanged event) {
    final name = FoodName.dirty(event.name ?? '');

    return state.copyWith(
      foodName: name,
      status: Formz.validate([
        name,
        state.dateConsumed,
        state.timeConsumed,
        state.calorieConsumed,
        state.amountConsumed,
        state.carbs,
        state.proteins,
        state.fats,
      ]),
    );
  }

  AddFoodItemState _mapCalorieAmountToState(AddFoodItemAmountChanged event) {
    final amount = AmountConsumed.dirty(event.value ?? '');

    return state.copyWith(
      amountConsumed: amount,
      status: Formz.validate([
        state.dateConsumed,
        state.timeConsumed,
        state.foodName,
        state.calorieConsumed,
        amount,
        state.carbs,
        state.proteins,
        state.fats,
      ]),
    );
  }

  AddFoodItemState _mapCalorieChangedToState(AddFoodItemCalorieChanged event) {
    final cal = CalorieConsumed.dirty(event.value ?? '');

    return state.copyWith(
      calorieConsumed: cal,
      status: Formz.validate([
        cal,
        state.dateConsumed,
        state.timeConsumed,
        state.foodName,
        state.amountConsumed,
        state.carbs,
        state.proteins,
        state.fats,
      ]),
    );
  }

  AddFoodItemState _mapCarbsChangedToState(AddFoodItemCarbsChanged event) {
    final AmountConsumed carbs = AmountConsumed.dirty(event.value ?? '');

    return state.copyWith(
      carbs: carbs,
      status: Formz.validate([
        carbs,
        state.amountConsumed,
        state.calorieConsumed,
        state.dateConsumed,
        state.fats,
        state.foodName,
        state.proteins,
        state.timeConsumed,
      ]),
    );
  }

  Stream<AddFoodItemState> _mapSubmitFormToState() async* {
    final date = DateConsumed.dirty(state.dateConsumed.value);
    final time = TimeConsumed.dirty(state.timeConsumed.value);
    final foodName = FoodName.dirty(state.foodName.value);
    final calorie = CalorieConsumed.dirty(state.calorieConsumed.value);
    final amount = AmountConsumed.dirty(state.amountConsumed.value);
    final fat = AmountConsumed.dirty(state.fats.value);
    final protein = AmountConsumed.dirty(state.proteins.value);
    final carb = AmountConsumed.dirty(state.carbs.value);

    yield state.copyWith(
      amountConsumed: amount,
      calorieConsumed: calorie,
      dateConsumed: date,
      foodName: foodName,
      timeConsumed: time,
      status: Formz.validate(
        [
          date,
          time,
          foodName,
          calorie,
          amount,
          fat,
          carb,
          protein,
        ],
      ),
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        final date = state.dateConsumed.value;
        final time = state.timeConsumed.value;

        FoodItem item = FoodItem(
          mealType: state.type,
          name: state.foodName.value,
          dateAdded: DateTime(date.year, date.month, date.day, time.hour, time.minute),
          calories: double.parse(state.calorieConsumed.value),
          amount: double.parse(state.amountConsumed.value),
          macronutrients: [
            FoodDataMacro(
              macronutrient: Macronutrient.fat,
              amount: double.parse(state.fats.value),
            ),
            FoodDataMacro(
              macronutrient: Macronutrient.carbs,
              amount: double.parse(state.carbs.value),
            ),
            FoodDataMacro(
              macronutrient: Macronutrient.protein,
              amount: double.parse(state.proteins.value),
            )
          ],
        );

        DocumentReference docRef = await _foodRepository.addFoodItem(_user!.id!, item);

        item = item.copyWith(id: docRef.id);

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          foodItem: item,
        );
      } on Exception catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  AddFoodItemState _mapProteinChangedToState(AddFoodItemProteinChanged event) {
    final protein = AmountConsumed.dirty(event.value ?? '');

    return state.copyWith(
      proteins: protein,
      status: Formz.validate(
        [
          protein,
          state.amountConsumed,
          state.calorieConsumed,
          state.dateConsumed,
          state.fats,
          state.foodName,
          state.carbs,
          state.timeConsumed,
        ],
      ),
    );
  }

  AddFoodItemState _mapFatChangedToState(AddFoodItemFatsChanged event) {
    final fat = AmountConsumed.dirty(event.value ?? '');

    return state.copyWith(
      fats: fat,
      status: Formz.validate(
        [
          fat,
          state.amountConsumed,
          state.calorieConsumed,
          state.dateConsumed,
          state.proteins,
          state.foodName,
          state.carbs,
          state.timeConsumed,
        ],
      ),
    );
  }
}

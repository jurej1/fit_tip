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
    FoodLogFocusedDateBloc? focusedDate,
    FoodItem? foodItem,
    required FoodRepository foodRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _foodRepository = foodRepository,
        _authenticationBloc = authenticationBloc,
        super(
          foodItem == null ? AddFoodItemState.pure(date: focusedDate?.state.selectedDate) : AddFoodItemState.dirty(item: foodItem),
        );

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
      yield* _mapTypeChangedToState(event);
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
    } else if (event is AddFoodItemShowDetailPressed) {
      yield state.copyWith(showDetail: !state.showDetail);
    } else if (event is AddFooditemVitaminAdded) {
      yield* _mapVitaminAddedToState(event);
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
          state.type,
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
        state.type
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
        state.type
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
        state.type
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
        state.type
      ]),
    );
  }

  AddFoodItemState _mapCarbsChangedToState(AddFoodItemCarbsChanged event) {
    final AmountDetailConsumed carbs = AmountDetailConsumed.dirty(event.value ?? '');

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
        state.type
      ]),
    );
  }

  Stream<AddFoodItemState> _mapSubmitFormToState() async* {
    final date = DateConsumed.dirty(state.dateConsumed.value);
    final time = TimeConsumed.dirty(state.timeConsumed.value);
    final foodName = FoodName.dirty(state.foodName.value);
    final calorie = CalorieConsumed.dirty(state.calorieConsumed.value);
    final amount = AmountConsumed.dirty(state.amountConsumed.value);
    final fat = AmountDetailConsumed.dirty(state.fats.value);
    final protein = AmountDetailConsumed.dirty(state.proteins.value);
    final carb = AmountDetailConsumed.dirty(state.carbs.value);
    final type = MealTypeInputFormzModel.dirty(state.type.value);

    yield state.copyWith(
      amountConsumed: amount,
      calorieConsumed: calorie,
      dateConsumed: date,
      foodName: foodName,
      timeConsumed: time,
      carbs: carb,
      fats: fat,
      proteins: protein,
      type: type,
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
          type,
        ],
      ),
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      try {
        final date = state.dateConsumed.value;
        final time = state.timeConsumed.value;

        final bool hasFats = state.fats.value.isNotEmpty;
        final bool hasCarbs = state.carbs.value.isNotEmpty;
        final bool hasProtein = state.proteins.value.isNotEmpty;
        final bool hasMacros = hasFats || hasCarbs || hasProtein;

        final bool hasVitamins = state.vitamins.isNotEmpty;

        FoodItem item = FoodItem(
          id: state.foodItem?.id,
          mealType: state.type.value,
          name: state.foodName.value,
          dateAdded: DateTime(date.year, date.month, date.day, time.hour, time.minute),
          calories: double.parse(state.calorieConsumed.value),
          amount: double.parse(state.amountConsumed.value),
          macronutrients: hasMacros
              ? [
                  if (hasFats)
                    FoodDataMacro(
                      macronutrient: Macronutrient.fat,
                      amount: double.parse(state.fats.value),
                    ),
                  if (hasCarbs)
                    FoodDataMacro(
                      macronutrient: Macronutrient.carbs,
                      amount: double.parse(state.carbs.value),
                    ),
                  if (hasProtein)
                    FoodDataMacro(
                      macronutrient: Macronutrient.protein,
                      amount: double.parse(state.proteins.value),
                    )
                ]
              : null,
          vitamins: hasVitamins ? state.vitamins : null,
        );

        if (state.mode == AddFoodItemStateMode.add) {
          DocumentReference docRef = await _foodRepository.addFoodItem(_user!.id!, item);

          item = item.copyWith(id: docRef.id);
        }

        if (state.mode == AddFoodItemStateMode.edit) {
          await _foodRepository.updateFoodItem(_user!.id!, item);
        }

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          foodItem: item,
        );
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  AddFoodItemState _mapProteinChangedToState(AddFoodItemProteinChanged event) {
    final protein = AmountDetailConsumed.dirty(event.value ?? '');

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
          state.type,
        ],
      ),
    );
  }

  AddFoodItemState _mapFatChangedToState(AddFoodItemFatsChanged event) {
    final fat = AmountDetailConsumed.dirty(event.value ?? '');

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
          state.type,
        ],
      ),
    );
  }

  Stream<AddFoodItemState> _mapVitaminAddedToState(AddFooditemVitaminAdded event) async* {
    if (event.vitamin != null) {
      List<FoodDataVitamin> list = List.from(state.vitamins);
      list.add(event.vitamin!);

      yield state.copyWith(vitamins: list);
    }
  }

  Stream<AddFoodItemState> _mapTypeChangedToState(AddFoodItemMealTypeChanged event) async* {
    if (event.value != null) {
      final type = MealTypeInputFormzModel.dirty(event.value!);

      yield state.copyWith(
        type: type,
        status: Formz.validate([
          type,
          state.amountConsumed,
          state.calorieConsumed,
          state.carbs,
          state.dateConsumed,
          state.fats,
          state.foodName,
          state.proteins,
          state.timeConsumed,
        ]),
      );
    }
  }
}

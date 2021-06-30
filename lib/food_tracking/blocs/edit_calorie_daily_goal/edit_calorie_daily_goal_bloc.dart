import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'edit_calorie_daily_goal_event.dart';
part 'edit_calorie_daily_goal_state.dart';

class EditCalorieDailyGoalBloc extends Bloc<EditCalorieDailyGoalEvent, EditCalorieDailyGoalState> {
  EditCalorieDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required FoodRepository foodRepository,
    required DaySelectorBloc foodLogFocusedDateBloc,
    required CalorieDailyGoalBloc calorieDailyGoalBloc,
  })  : _authenticationBloc = authenticationBloc,
        _foodLogFocusedDateBloc = foodLogFocusedDateBloc,
        _foodRepository = foodRepository,
        super(EditCalorieDailyGoalState.dirty((calorieDailyGoalBloc.state as CalorieDailyGoalLoadSuccess).calorieDailyGoal));

  final AuthenticationBloc _authenticationBloc;
  final FoodRepository _foodRepository;
  final DaySelectorBloc _foodLogFocusedDateBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<EditCalorieDailyGoalState> mapEventToState(
    EditCalorieDailyGoalEvent event,
  ) async* {
    if (event is EditCalorieDailyGoalAmountChanged) {
      yield _mapAmountChangedToState(event);
    } else if (event is EditCalorieDailyGoalFormSubmit) {
      yield* _mapFormSubmitToState();
    } else if (event is EditCalorieDailyGoalProteinChanged) {
      yield _mapProteinChangedToState(event);
    } else if (event is EditCalorieDailyGoalCarbsChanged) {
      yield _mapCarbsChangedToState(event);
    } else if (event is EditCalorieDailyGoalFatsChanged) {
      yield _mapFatsChangedToState(event);
    } else if (event is EditCalorieDailyGoalBreakfastChanged) {
      yield _mapBreakfastChangedToState(event);
    } else if (event is EditCalorieDailyGoalLunchChanged) {
      yield _mapLunchChangedToState(event);
    } else if (event is EditCalorieDailyGoalDinnerChanged) {
      yield _mapDinnerChangedToState(event);
    } else if (event is EditCalorieDailyGoalSnackChanged) {
      yield _mapSnackChangedToState(event);
    }
  }

  EditCalorieDailyGoalState _mapAmountChangedToState(EditCalorieDailyGoalAmountChanged event) {
    CalorieDailyConsumptionGoal consumption = CalorieDailyConsumptionGoal.dirty(
      value: event.amount,
      breakfast: state.breakfast.value,
      dinner: state.dinner.value,
      lunch: state.lunch.value,
      snack: state.snack.value,
    );

    return state.copyWith(
      calorieGoalConsumption: consumption,
      status: Formz.validate(
        [
          consumption,
          state.breakfast,
          state.lunch,
          state.dinner,
          state.snack,
          state.fats,
          state.carbs,
          state.proteins,
        ],
      ),
    );
  }

  Stream<EditCalorieDailyGoalState> _mapFormSubmitToState() async* {
    CalorieDailyConsumptionGoal consumption = CalorieDailyConsumptionGoal.dirty(
      value: state.calorieDailyConsumptionGoal.value,
      breakfast: state.breakfast.value,
      dinner: state.dinner.value,
      lunch: state.lunch.value,
      snack: state.snack.value,
    );
    final fats = AmountDetailConsumed.dirty(state.fats.value);
    final carbs = AmountDetailConsumed.dirty(state.carbs.value);
    final proteins = AmountDetailConsumed.dirty(state.proteins.value);
    final breakfast = CalorieGoalConsumption.dirty(state.breakfast.value);
    final lunch = CalorieGoalConsumption.dirty(state.lunch.value);
    final dinner = CalorieGoalConsumption.dirty(state.dinner.value);
    final snack = CalorieGoalConsumption.dirty(state.snack.value);

    yield state.copyWith(
      status: Formz.validate([
        consumption,
        fats,
        proteins,
        carbs,
        snack,
        dinner,
        lunch,
        breakfast,
      ]),
      carbs: carbs,
      breakfast: breakfast,
      dinner: dinner,
      lunch: lunch,
      snack: snack,
      fats: fats,
      proteins: proteins,
      calorieGoalConsumption: consumption,
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      int? carbsValue = int.tryParse(carbs.value);
      int? proteinValue = int.tryParse(proteins.value);
      int? fatsValue = int.tryParse(fats.value);
      int? breakfastValue = int.tryParse(breakfast.value);
      int? lunchValue = int.tryParse(lunch.value);
      int? snackValue = int.tryParse(snack.value);
      int? dinnerValue = int.tryParse(dinner.value);

      CalorieDailyGoal goal = state.goal.copyWith(
        amount: int.parse(state.calorieDailyConsumptionGoal.value),
        date: _foodLogFocusedDateBloc.state.selectedDate,
        carbs: carbsValue,
        proteins: proteinValue,
        fats: fatsValue,
        breakfast: breakfastValue,
        dinner: dinnerValue,
        lunch: lunchValue,
        snack: snackValue,
      );

      try {
        await _foodRepository.addCalorieDailyGoal(_user!.id!, goal);
        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          goal: goal,
        );
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }

  EditCalorieDailyGoalState _mapProteinChangedToState(EditCalorieDailyGoalProteinChanged event) {
    AmountDetailConsumed protein = AmountDetailConsumed.dirty(event.amount);

    return state.copyWith(
      proteins: protein,
      status: Formz.validate(
        [
          protein,
          state.carbs,
          state.fats,
          state.calorieDailyConsumptionGoal,
          state.breakfast,
          state.lunch,
          state.dinner,
          state.snack,
        ],
      ),
    );
  }

  EditCalorieDailyGoalState _mapCarbsChangedToState(EditCalorieDailyGoalCarbsChanged event) {
    final carbs = AmountDetailConsumed.dirty(event.amount);

    return state.copyWith(
      status: Formz.validate(
        [
          carbs,
          state.proteins,
          state.fats,
          state.calorieDailyConsumptionGoal,
          state.breakfast,
          state.lunch,
          state.dinner,
          state.snack,
        ],
      ),
      carbs: carbs,
    );
  }

  EditCalorieDailyGoalState _mapFatsChangedToState(EditCalorieDailyGoalFatsChanged event) {
    final fats = AmountDetailConsumed.dirty(event.amount);

    return state.copyWith(
      status: Formz.validate([
        fats,
        state.proteins,
        state.calorieDailyConsumptionGoal,
        state.carbs,
        state.breakfast,
        state.dinner,
        state.lunch,
        state.snack,
      ]),
      fats: fats,
    );
  }

  EditCalorieDailyGoalState _mapBreakfastChangedToState(EditCalorieDailyGoalBreakfastChanged event) {
    final breakfast = CalorieGoalConsumption.dirty(event.value);
    return state.copyWith(
      breakfast: breakfast,
      status: Formz.validate(
        [
          breakfast,
          state.calorieDailyConsumptionGoal,
          state.carbs,
          state.fats,
          state.dinner,
          state.lunch,
          state.proteins,
          state.snack,
        ],
      ),
    );
  }

  EditCalorieDailyGoalState _mapLunchChangedToState(EditCalorieDailyGoalLunchChanged event) {
    final lunch = CalorieGoalConsumption.dirty(event.value);

    return state.copyWith(
      lunch: lunch,
      status: Formz.validate(
        [
          lunch,
          state.calorieDailyConsumptionGoal,
          state.proteins,
          state.fats,
          state.carbs,
          state.breakfast,
          state.dinner,
          state.snack,
        ],
      ),
    );
  }

  EditCalorieDailyGoalState _mapDinnerChangedToState(EditCalorieDailyGoalDinnerChanged event) {
    final dinner = CalorieGoalConsumption.dirty(event.value);

    return state.copyWith(
      dinner: dinner,
      status: Formz.validate(
        [
          dinner,
          state.breakfast,
          state.lunch,
          state.snack,
          state.calorieDailyConsumptionGoal,
          state.carbs,
          state.fats,
          state.proteins,
        ],
      ),
    );
  }

  EditCalorieDailyGoalState _mapSnackChangedToState(EditCalorieDailyGoalSnackChanged event) {
    final snack = CalorieGoalConsumption.dirty(event.value);

    return state.copyWith(
      snack: snack,
      status: Formz.validate(
        [
          snack,
          state.breakfast,
          state.lunch,
          state.dinner,
          state.calorieDailyConsumptionGoal,
          state.carbs,
          state.proteins,
          state.fats,
        ],
      ),
    );
  }
}

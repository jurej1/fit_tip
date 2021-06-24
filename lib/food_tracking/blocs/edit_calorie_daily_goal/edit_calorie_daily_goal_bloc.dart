import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'edit_calorie_daily_goal_event.dart';
part 'edit_calorie_daily_goal_state.dart';

class EditCalorieDailyGoalBloc extends Bloc<EditCalorieDailyGoalEvent, EditCalorieDailyGoalState> {
  EditCalorieDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required FoodRepository foodRepository,
    required FoodLogFocusedDateBloc foodLogFocusedDateBloc,
    required CalorieDailyGoalBloc calorieDailyGoalBloc,
  })   : _authenticationBloc = authenticationBloc,
        _foodLogFocusedDateBloc = foodLogFocusedDateBloc,
        _foodRepository = foodRepository,
        super(EditCalorieDailyGoalState.dirty((calorieDailyGoalBloc.state as CalorieDailyGoalLoadSuccess).calorieDailyGoal));

  final AuthenticationBloc _authenticationBloc;
  final FoodRepository _foodRepository;
  final FoodLogFocusedDateBloc _foodLogFocusedDateBloc;

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
    }
  }

  EditCalorieDailyGoalState _mapAmountChangedToState(EditCalorieDailyGoalAmountChanged event) {
    CalorieGoalConsumption consumption = CalorieGoalConsumption.dirty(event.amount ?? '');

    return state.copyWith(
      calorieGoalConsumption: consumption,
      status: Formz.validate([consumption]),
    );
  }

  Stream<EditCalorieDailyGoalState> _mapFormSubmitToState() async* {
    CalorieGoalConsumption consumption = CalorieGoalConsumption.dirty(state.calorieGoalConsumption.value);
    final fats = AmountDetailConsumed.dirty(state.fats.value);
    final carbs = AmountDetailConsumed.dirty(state.carbs.value);
    final proteins = AmountDetailConsumed.dirty(state.proteins.value);

    yield state.copyWith(
      status: Formz.validate([
        consumption,
        fats,
        proteins,
        carbs,
      ]),
      carbs: carbs,
      fats: fats,
      proteins: proteins,
      calorieGoalConsumption: consumption,
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      int? carbsValue = int.tryParse(carbs.value);
      int? proteinValue = int.tryParse(proteins.value);
      int? fatsValue = int.tryParse(fats.value);

      CalorieDailyGoal goal = state.goal.copyWith(
        amount: double.parse(state.calorieGoalConsumption.value),
        date: _foodLogFocusedDateBloc.state.selectedDate,
        carbs: carbsValue,
        proteins: proteinValue,
        fats: fatsValue,
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
          state.calorieGoalConsumption,
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
          state.calorieGoalConsumption,
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
        state.calorieGoalConsumption,
        state.carbs,
      ]),
      fats: fats,
    );
  }
}

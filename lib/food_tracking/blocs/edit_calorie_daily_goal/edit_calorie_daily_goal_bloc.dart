import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'edit_calorie_daily_goal_event.dart';
part 'edit_calorie_daily_goal_state.dart';

class EditCalorieDailyGoalBloc extends Bloc<EditCalorieDailyGoalEvent, EditCalorieDailyGoalState> {
  EditCalorieDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required FoodRepository foodRepository,
    required FoodLogFocusedDateBloc foodLogFocusedDateBloc,
  })   : _authenticationBloc = authenticationBloc,
        _foodLogFocusedDateBloc = foodLogFocusedDateBloc,
        _foodRepository = foodRepository,
        super(EditCalorieDailyGoalState());

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

    yield state.copyWith(
      status: Formz.validate([consumption]),
      calorieGoalConsumption: consumption,
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      CalorieDailyGoal goal = CalorieDailyGoal(
        amount: double.parse(state.calorieGoalConsumption.value),
        date: _foodLogFocusedDateBloc.state.selectedDate,
      );

      try {
        await _foodRepository.addCalorieDailyGoal(_user!.id!, goal);
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}

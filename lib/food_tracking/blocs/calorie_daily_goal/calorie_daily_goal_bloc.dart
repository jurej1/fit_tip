import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:food_repository/food_repository.dart';

part 'calorie_daily_goal_event.dart';
part 'calorie_daily_goal_state.dart';

class CalorieDailyGoalBloc extends Bloc<CalorieDailyGoalEvent, CalorieDailyGoalState> {
  CalorieDailyGoalBloc({
    required FoodRepository foodRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _foodRepository = foodRepository,
        _authenticationBloc = authenticationBloc,
        super(CalorieDailyGoalLoading());

  final AuthenticationBloc _authenticationBloc;
  final FoodRepository _foodRepository;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get user => _authenticationBloc.state.user;

  @override
  Stream<CalorieDailyGoalState> mapEventToState(
    CalorieDailyGoalEvent event,
  ) async* {
    if (event is CalorieDailyGoalFocusedDateUpdated) {
      yield* _mapFocusedDateUpdatedToState(event);
    } else if (event is CalorieDailyGoalUpdated) {
      yield* _mapCalorieGoalUpdatedToState(event);
    }
  }

  Stream<CalorieDailyGoalState> _mapFocusedDateUpdatedToState(CalorieDailyGoalFocusedDateUpdated event) async* {
    if (state is CalorieDailyGoalLoadSuccess) return;

    if (_isAuth && event.date != null) {
      yield CalorieDailyGoalLoading();

      try {
        CalorieDailyGoal calorieDailyGoal = await _foodRepository.getCalorieDailyGoalForSpecificDate(user!.id!, event.date!);

        yield CalorieDailyGoalLoadSuccess(calorieDailyGoal: calorieDailyGoal);
      } catch (e) {
        yield CalorieDailyGoalFailure(errorMsg: e.toString());
      }
    }
  }

  Stream<CalorieDailyGoalState> _mapCalorieGoalUpdatedToState(CalorieDailyGoalUpdated event) async* {
    if (_isAuth && event.calorieDailyGoal != null && state is CalorieDailyGoalLoadSuccess) {
      CalorieDailyGoal updatedGoal = event.calorieDailyGoal!;
      yield CalorieDailyGoalLoadSuccess(calorieDailyGoal: updatedGoal);
    }
  }
}

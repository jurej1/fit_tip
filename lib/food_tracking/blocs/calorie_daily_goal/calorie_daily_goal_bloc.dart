import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

part 'calorie_daily_goal_event.dart';
part 'calorie_daily_goal_state.dart';

class CalorieDailyGoalBloc extends Bloc<CalorieDailyGoalEvent, CalorieDailyGoalState> {
  CalorieDailyGoalBloc({
    required FoodRepository foodRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _foodRepository = foodRepository,
        super(CalorieDailyGoalLoading()) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final FoodRepository _foodRepository;
  late final StreamSubscription _authSubscription;

  String? _userId;
  bool _isAuth = false;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
        CalorieDailyGoal calorieDailyGoal = await _foodRepository.getCalorieDailyGoalForSpecificDate(_userId!, event.date!);

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

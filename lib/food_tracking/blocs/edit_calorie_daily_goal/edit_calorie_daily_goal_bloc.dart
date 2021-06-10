import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

part 'edit_calorie_daily_goal_event.dart';
part 'edit_calorie_daily_goal_state.dart';

class EditCalorieDailyGoalBloc extends Bloc<EditCalorieDailyGoalEvent, EditCalorieDailyGoalState> {
  EditCalorieDailyGoalBloc() : super(EditCalorieDailyGoalState());

  @override
  Stream<EditCalorieDailyGoalState> mapEventToState(
    EditCalorieDailyGoalEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

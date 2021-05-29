import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'water_daily_goal_event.dart';
part 'water_daily_goal_state.dart';

class WaterDailyGoalBloc extends Bloc<WaterDailyGoalEvent, WaterDailyGoalState> {
  WaterDailyGoalBloc() : super(WaterDailyGoalInitial());

  @override
  Stream<WaterDailyGoalState> mapEventToState(
    WaterDailyGoalEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

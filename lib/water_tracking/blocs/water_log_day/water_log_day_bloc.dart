import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:water_repository/models/models.dart';

part 'water_log_day_event.dart';
part 'water_log_day_state.dart';

class WaterLogDayBloc extends Bloc<WaterLogDayEvent, WaterLogDayState> {
  WaterLogDayBloc({
    required WaterLogFocusedDayBloc waterLogFocusedDayBloc,
  }) : super(WaterLogDayLoading());

  @override
  Stream<WaterLogDayState> mapEventToState(
    WaterLogDayEvent event,
  ) async* {}
}

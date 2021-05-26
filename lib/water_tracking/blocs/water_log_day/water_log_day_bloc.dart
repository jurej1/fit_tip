import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/blocs/blocs.dart';
import 'package:water_repository/models/models.dart';
import 'package:water_repository/water_repository.dart';

part 'water_log_day_event.dart';
part 'water_log_day_state.dart';

class WaterLogDayBloc extends Bloc<WaterLogDayEvent, WaterLogDayState> {
  WaterLogDayBloc({
    required WaterRepository waterRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _waterRepository = waterRepository,
        _authenticationBloc = authenticationBloc,
        super(WaterLogDayLoading());

  final WaterRepository _waterRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<WaterLogDayState> mapEventToState(
    WaterLogDayEvent event,
  ) async* {
    if (event is WaterLogFocusedDayUpdated) {
      yield* _mapWaterLogFocusedDayUpdatedToState(event);
    } else if (event is WaterLogAddede) {
      yield* _mapWaterLogAddedToState(event);
    } else if (event is WaterLogRemoved) {
      yield* _mapWaterLogRemovedToState(event);
    } else if (event is WaterLogUpdated) {
      yield* _mapWaterLogUpdatedToState(event);
    }
  }

  Stream<WaterLogDayState> _mapWaterLogFocusedDayUpdatedToState(WaterLogFocusedDayUpdated event) async* {
    if (!_authenticationBloc.state.isAuthenticated) {
      yield WaterLogDayFailure();
      return;
    }

    yield WaterLogDayLoading();

    try {
      List<WaterLog> waterLogs = (await _waterRepository.getWaterLogForDay(event.dateTime))!;

      yield WaterLogDayLoadSuccess(waterLogs: waterLogs);
    } catch (error) {
      print('Error' + error.toString());
      yield WaterLogDayFailure(errorMsg: error.toString());
    }
  }

  Stream<WaterLogDayState> _mapWaterLogAddedToState(WaterLogAddede event) async* {
    if (state is WaterLogDayLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final currentState = state as WaterLogDayLoadSuccess;

      List<WaterLog> logsCopy = List.from(currentState.waterLogs);

      logsCopy.add(event.waterLog);

      logsCopy.sort();

      yield WaterLogDayLoadSuccess(waterLogs: logsCopy);
    }
  }

  Stream<WaterLogDayState> _mapWaterLogRemovedToState(WaterLogRemoved event) async* {
    if (state is WaterLogDayLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final currentState = state as WaterLogDayLoadSuccess;

      List<WaterLog> logsCopy = List.from(currentState.waterLogs);

      logsCopy.removeWhere((element) => event.waterLog.id == element.id);

      yield WaterLogDayLoadSuccess(waterLogs: logsCopy);
    }
  }

  Stream<WaterLogDayState> _mapWaterLogUpdatedToState(WaterLogUpdated event) async* {
    if (state is WaterLogDayLoadSuccess && _authenticationBloc.state.isAuthenticated) {
      final currentState = state as WaterLogDayLoadSuccess;

      List<WaterLog> logsCopy = List.from(currentState.waterLogs);

      logsCopy = logsCopy.map((e) {
        if (e.id == event.waterLog.id) {
          return event.waterLog;
        }
        return e;
      }).toList();

      yield WaterLogDayLoadSuccess(waterLogs: logsCopy);
    }
  }
}

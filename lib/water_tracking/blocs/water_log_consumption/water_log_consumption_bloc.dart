import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';

part 'water_log_consumption_event.dart';
part 'water_log_consumption_state.dart';

class WaterLogConsumptionBloc extends Bloc<WaterLogConsumptionEvent, WaterLogConsumptionState> {
  WaterLogConsumptionBloc({
    required WaterDailyGoalBloc waterDailyGoalBloc,
    required WaterLogDayBloc waterLogDayBloc,
  })   : _waterLogDayBloc = waterLogDayBloc,
        _waterDailyGoalBloc = waterDailyGoalBloc,
        super(WaterLogConsumptionLoading()) {
    final logState = _waterLogDayBloc.state;

    if (logState is WaterLogDayLoadSuccess) {
      add(WaterLogConsumptionDayAmountUpdated(logState.totalDrinked));
    }

    final goalState = _waterDailyGoalBloc.state;
    if (goalState is WaterDailyGoalLoadSuccess) {
      add(WaterLogConsumptionGoalAmountUpdated(goalState.goal.amount));
    }

    if (goalState is WaterDailyGoalFailure || logState is WaterLogDayFailure) {
      add(WaterLogConsumptionRequestError());
    }

    _goalSubscription = _waterDailyGoalBloc.stream.listen((goalState) {
      if (goalState is WaterDailyGoalLoadSuccess) {
        add(WaterLogConsumptionGoalAmountUpdated(goalState.goal.amount));
      } else if (goalState is WaterDailyGoalFailure) {
        add(WaterLogConsumptionRequestError());
      }
    });

    _logSubscription = _waterLogDayBloc.stream.listen((logState) {
      if (logState is WaterLogDayLoadSuccess) {
        add(WaterLogConsumptionDayAmountUpdated(logState.totalDrinked));
      } else if (logState is WaterLogDayFailure) {
        add(WaterLogConsumptionRequestError());
      }
    });
  }

  late final StreamSubscription _goalSubscription;
  late final StreamSubscription _logSubscription;
  final WaterDailyGoalBloc _waterDailyGoalBloc;
  final WaterLogDayBloc _waterLogDayBloc;

  WaterDailyGoalState get _goalState => _waterDailyGoalBloc.state;
  WaterLogDayState get _logState => _waterLogDayBloc.state;

  @override
  Stream<WaterLogConsumptionState> mapEventToState(
    WaterLogConsumptionEvent event,
  ) async* {
    if (event is WaterLogConsumptionGoalAmountUpdated) {
      yield* _mapGoalAmountUpdatedToState(event);
    } else if (event is WaterLogConsumptionDayAmountUpdated) {
      yield* _mapDayAmountUpdatedToState(event);
    } else if (event is WaterLogConsumptionRequestError) {
      yield WaterLogConsumptionFailure();
    }
  }

  Stream<WaterLogConsumptionState> _mapGoalAmountUpdatedToState(WaterLogConsumptionGoalAmountUpdated event) async* {
    if (_logState is WaterLogDayLoadSuccess) {
      yield WaterLogConsumptionLoadSucccess(
        amount: (_logState as WaterLogDayLoadSuccess).totalDrinked,
        max: event.amount,
      );
    }
  }

  Stream<WaterLogConsumptionState> _mapDayAmountUpdatedToState(WaterLogConsumptionDayAmountUpdated event) async* {
    if (_goalState is WaterDailyGoalLoadSuccess) {
      yield WaterLogConsumptionLoadSucccess(
        amount: event.amount,
        max: (_goalState as WaterDailyGoalLoadSuccess).goal.amount,
      );
    }
  }

  @override
  Future<void> close() {
    _goalSubscription.cancel();
    _logSubscription.cancel();
    return super.close();
  }
}

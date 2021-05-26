import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:water_repository/models/models.dart';
import 'package:water_repository/water_repository.dart';

part 'water_grid_tile_event.dart';
part 'water_grid_tile_state.dart';

class WaterGridTileBloc extends Bloc<WaterGridTileEvent, WaterGridTileState> {
  WaterGridTileBloc({
    required WaterLog waterLog,
    required AuthenticationBloc authenticationBloc,
    required WaterRepository waterRepository,
  })   : _authenticationBloc = authenticationBloc,
        _waterRepository = waterRepository,
        super(WaterGridTileInitial(waterLog));

  final AuthenticationBloc _authenticationBloc;
  final WaterRepository _waterRepository;

  @override
  Stream<WaterGridTileState> mapEventToState(
    WaterGridTileEvent event,
  ) async* {
    if (event is WaterGridTileDeleteRequested) {
      yield* _mapDeleteRequestedToState();
    } else if (event is WaterGridTileBlocSliderUpdated) {
      final waterCup = state.waterLog.cup;

      yield WaterGridTileInitial(state.waterLog.copyWith(cup: waterCup.copyWith(amount: event.val)));
    } else if (event is WaterGridTileDialogClosed) {
      if (_authenticationBloc.state.isAuthenticated && !(state is WaterGridTileDeletingSuccess))
        await _waterRepository.updateWaterLog(state.waterLog);
    } else if (event is WaterGridTileTimeUpdated) {
      yield WaterGridTileInitial(state.waterLog.copyWith(time: event.time));
    }
  }

  Stream<WaterGridTileState> _mapDeleteRequestedToState() async* {
    if (!_authenticationBloc.state.isAuthenticated) return;

    yield WaterGridTileLoading(state.waterLog);

    try {
      await _waterRepository.deleteWaterLog(state.waterLog);
      yield WaterGridTileDeletingSuccess(state.waterLog);
    } catch (error) {
      yield WaterGridTileDeletingFailure(state.waterLog);
    }
  }
}

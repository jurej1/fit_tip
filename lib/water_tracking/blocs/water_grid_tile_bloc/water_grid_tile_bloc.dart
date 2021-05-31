import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart' as rep;
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

  rep.User? get user => _authenticationBloc.state.user;
  bool get isAuth => _authenticationBloc.state.isAuthenticated;

  @override
  Stream<WaterGridTileState> mapEventToState(
    WaterGridTileEvent event,
  ) async* {
    if (event is WaterGridTileDeleteRequested) {
      yield* _mapDeleteRequestedToState();
    } else if (event is WaterGridTileBlocSliderUpdated) {
      final waterCup = state.waterLog.cup;

      yield WaterGridTileDirty(state.waterLog.copyWith(cup: waterCup.copyWith(amount: event.val)));
    } else if (event is WaterGridTileDialogClosed) {
      if (isAuth && !(state is WaterGridTileDeletingSuccess) && (state is WaterGridTileDirty)) {
        _waterRepository.updateWaterLog(user!.id!, state.waterLog);
      }
    } else if (event is WaterGridTileTimeUpdated) {
      yield WaterGridTileInitial(state.waterLog.copyWith(time: event.time));
    }
  }

  Stream<WaterGridTileState> _mapDeleteRequestedToState() async* {
    if (!isAuth) return;

    yield WaterGridTileLoading(state.waterLog);

    try {
      await _waterRepository.deleteWaterLog(user!.id!, state.waterLog);
      yield WaterGridTileDeletingSuccess(state.waterLog);
    } catch (error) {
      yield WaterGridTileFailure(state.waterLog);
    }
  }
}

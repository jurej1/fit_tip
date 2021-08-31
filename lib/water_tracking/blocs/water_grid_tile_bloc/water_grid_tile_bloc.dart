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
  })  : _waterRepository = waterRepository,
        super(WaterGridTileInitial(waterLog)) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final WaterRepository _waterRepository;
  late final StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
      if (_isAuth && !(state is WaterGridTileDeletingSuccess) && (state is WaterGridTileDirty)) {
        _waterRepository.updateWaterLog(_userId!, state.waterLog);
      }
    } else if (event is WaterGridTileTimeUpdated) {
      yield WaterGridTileInitial(state.waterLog.copyWith(time: event.time));
    }
  }

  Stream<WaterGridTileState> _mapDeleteRequestedToState() async* {
    if (!_isAuth) return;

    yield WaterGridTileLoading(state.waterLog);

    try {
      await _waterRepository.deleteWaterLog(_userId!, state.waterLog);
      yield WaterGridTileDeletingSuccess(state.waterLog);
    } catch (error) {
      yield WaterGridTileFailure(state.waterLog);
    }
  }
}

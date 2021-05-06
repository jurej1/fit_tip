import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_tile_event.dart';
part 'weight_tile_state.dart';

class WeightTileBloc extends Bloc<WeightTileEvent, WeightTileState> {
  WeightTileBloc({
    required WeightRepository weightRepository,
    required Weight weight,
  })   : _weightRepository = weightRepository,
        _weight = weight,
        super(WeightTileInitial());

  final WeightRepository _weightRepository;
  final Weight _weight;

  @override
  Stream<WeightTileState> mapEventToState(
    WeightTileEvent event,
  ) async* {
    if (event is WeightTileDeleteShort) {
      yield* _mapTileDeleteToMap();
    } else if (event is WeightTileCancelDeleting) {
      yield WeightTileDeletingCanceled(_weight);
    } else if (event is WeightTileSnackbarClosed) {
      yield* _mapSnackbarClosedToState(event);
    }
  }

  Stream<WeightTileState> _mapTileDeleteToMap() async* {
    yield WeightTileShortDeleted(_weight);
  }

  Stream<WeightTileState> _mapSnackbarClosedToState(WeightTileSnackbarClosed event) async* {
    if (event.closeReason == SnackBarClosedReason.action) {
      return;
    }
    yield WeightTileDeleteLoading();

    try {
      if (_weight.id == null) {
        yield WeightTileDeleteFail();
        return;
      }
      await _weightRepository.deleteWeight(_weight.id!);

      yield WeightTileTotalDeleted(_weight);
    } catch (errpr) {
      yield WeightTileDeleteFail();
    }
  }
}

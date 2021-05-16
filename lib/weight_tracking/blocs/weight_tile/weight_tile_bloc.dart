import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    if (event is WeightTileDeleteRequested) {
      yield* _mapSnackbarClosedToState(event);
    }
  }

  Stream<WeightTileState> _mapSnackbarClosedToState(WeightTileDeleteRequested event) async* {
    yield WeightTileDeleteLoading();

    try {
      if (_weight.id == null) {
        yield WeightTileDeleteFail();
        return;
      }
      await _weightRepository.deleteWeight(_weight.id!);

      yield WeightTileDeletedSuccessfully(_weight);
    } catch (errpr) {
      yield WeightTileDeleteFail();
    }
  }
}

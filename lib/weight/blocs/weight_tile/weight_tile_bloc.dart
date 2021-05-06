import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_tile_event.dart';
part 'weight_tile_state.dart';

class WeightTileBloc extends Bloc<WeightTileEvent, WeightTileState> {
  WeightTileBloc({
    required WeightRepository weightRepository,
  })   : _weightRepository = weightRepository,
        super(WeightTileInitial());

  final WeightRepository _weightRepository;

  @override
  Stream<WeightTileState> mapEventToState(
    WeightTileEvent event,
  ) async* {
    if (event is WeightTileDelete) {
      yield* _mapTileDeleteToMap(event);
    }
  }

  Stream<WeightTileState> _mapTileDeleteToMap(WeightTileDelete event) async* {
    yield WeightTileDeleteLoading();

    try {
      await _weightRepository.deleteWeight(event.weight.id!);

      yield WeightTileSuccessfullyDeleted(event.weight);
    } catch (error) {
      yield WeightTileDeleteFail();
    }
  }
}

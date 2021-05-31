import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_tile_event.dart';
part 'weight_tile_state.dart';

class WeightTileBloc extends Bloc<WeightTileEvent, WeightTileState> {
  WeightTileBloc({
    required WeightRepository weightRepository,
    required Weight weight,
    required AuthenticationBloc authenticationBloc,
  })   : _weightRepository = weightRepository,
        _authenticationBloc = authenticationBloc,
        super(WeightTileInitial(weight));

  final WeightRepository _weightRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<WeightTileState> mapEventToState(
    WeightTileEvent event,
  ) async* {
    if (event is WeightTileDeleteRequested) {
      yield* _mapSnackbarClosedToState(event);
    }
  }

  Stream<WeightTileState> _mapSnackbarClosedToState(WeightTileDeleteRequested event) async* {
    yield WeightTileDeleteLoading(state.weight);

    try {
      if (state.weight.id == null) {
        yield WeightTileDeleteFail(state.weight);
        return;
      }
      await _weightRepository.deleteWeight(_authenticationBloc.state.user!.id!, state.weight.id!);

      yield WeightTileDeletedSuccessfully(state.weight);
    } catch (errpr) {
      yield WeightTileDeleteFail(state.weight);
    }
  }
}

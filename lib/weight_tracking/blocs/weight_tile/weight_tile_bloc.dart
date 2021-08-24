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
  })  : _weightRepository = weightRepository,
        super(WeightTileInitial(weight)) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final WeightRepository _weightRepository;
  late final StreamSubscription _authSubscription;

  String? _userId;
  bool _isAuth = false;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<WeightTileState> mapEventToState(
    WeightTileEvent event,
  ) async* {
    if (event is WeightTileDeleteRequested) {
      yield* _mapSnackbarClosedToState(event);
    }
  }

  Stream<WeightTileState> _mapSnackbarClosedToState(WeightTileDeleteRequested event) async* {
    if (_isAuth) {
      yield WeightTileDeleteLoading(state.weight);

      try {
        if (state.weight.id == null) {
          yield WeightTileDeleteFail(state.weight);
          return;
        }
        await _weightRepository.deleteWeight(_userId!, state.weight.id!);

        yield WeightTileDeletedSuccessfully(state.weight);
      } catch (error) {
        yield WeightTileDeleteFail(state.weight);
      }
    }
  }
}

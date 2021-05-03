import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_history_event.dart';
part 'weight_history_state.dart';

class WeightHistoryBloc extends Bloc<WeightHistoryEvent, WeightHistoryState> {
  WeightHistoryBloc({
    required WeightRepository weightRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _weightRepository = weightRepository,
        _authenticationBloc = authenticationBloc,
        super(WeightHistoryLoading());

  final WeightRepository _weightRepository;
  final AuthenticationBloc _authenticationBloc;
  @override
  Stream<WeightHistoryState> mapEventToState(
    WeightHistoryEvent event,
  ) async* {
    if (event is WeightHistoryLoad) {
      yield* _mapWeighHistoryLoadToState();
    } else if (event is WeightHistoryAdded) {
      yield* _mapWeightHistoryAddedToState(event);
    } else if (event is WeightHistoryDelete) {
      yield* _mapWeightHistoryDeletedToState(event);
    }
  }

  Stream<WeightHistoryState> _mapWeighHistoryLoadToState() async* {
    if (state is WeightHistorySuccesfullyLoaded) {
      return;
    }

    if (_authenticationBloc.state.status != AuthenticationStatus.authenticated) {
      yield WeightHistoryFailure();
      return;
    }

    try {
      yield WeightHistoryLoading();

      final weights = await _weightRepository.weightHistory();

      if (weights == null) {
        yield WeightHistoryFailure();
        return;
      }

      yield WeightHistorySuccesfullyLoaded(weights: weights);
    } catch (error) {
      yield WeightHistoryFailure();
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryAddedToState(WeightHistoryAdded event) async* {
    if (_authenticationBloc.state.status == AuthenticationStatus.authenticated &&
        state is _WeightHistoryLoadSucces &&
        event.weight != null) {
      final currentState = state as _WeightHistoryLoadSucces;

      List<Weight> weights = currentState.weights;

      weights = weights..add(event.weight!);

      weights = weights..sort((a, b) => a.date!.compareTo(b.date!));

      yield WeightHistorySuccesfullyLoaded(weights: weights);
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryDeletedToState(WeightHistoryDelete event) async* {
    if (_authenticationBloc.state.status == AuthenticationStatus.authenticated &&
        state is _WeightHistoryLoadSucces &&
        event.weight != null) {
      final currentState = state as _WeightHistoryLoadSucces;

      await _weightRepository.deleteWeight(event.weight!.id!);

      List<Weight> weights = currentState.weights;
      weights.removeWhere((element) => element.id == event.weight!.id);

      yield WeightHistoryWeightDeleted(weights: weights);
    }
  }
}

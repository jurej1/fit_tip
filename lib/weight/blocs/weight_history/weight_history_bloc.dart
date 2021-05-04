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
    if (state is WeightHistoryLoadSucces) {
      return;
    }

    if (_authenticationBloc.state.status != AuthenticationStatus.authenticated) {
      yield WeightHistoryFailure();
      return;
    }

    try {
      yield WeightHistoryLoading();

      var weights = await _weightRepository.weightHistory();

      if (weights == null) {
        yield WeightHistoryFailure();
        return;
      }

      final user = _authenticationBloc.state.user;

      if (user!.measurmentSystem != MeasurmentSystem.metric) {
        weights = weights
            .map(
              (e) => e.copyWith(
                weight: MeasurmentSystemConverter.kgToLb(e.weight?.toDouble() ?? 0.0),
              ),
            )
            .toList();
      }

      yield WeightHistoryLoadSucces(weights: weights);
    } catch (error) {
      yield WeightHistoryFailure();
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryAddedToState(WeightHistoryAdded event) async* {
    if (_authenticationBloc.state.status == AuthenticationStatus.authenticated &&
        state is WeightHistoryLoadSucces &&
        event.weight != null) {
      final currentState = state as WeightHistoryLoadSucces;

      List<Weight> weights = currentState.weights;

      weights = weights..add(event.weight!);

      weights = weights..sort((a, b) => b.date!.compareTo(a.date!));

      yield WeightHistoryLoadSucces(weights: weights);
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryDeletedToState(WeightHistoryDelete event) async* {
    if (_authenticationBloc.state.status == AuthenticationStatus.authenticated &&
        state is WeightHistoryLoadSucces &&
        event.weight != null) {
      final currentState = state as WeightHistoryLoadSucces;

      List<Weight> weights = currentState.weights;

      weights.removeWhere((element) => element.id == event.weight!.id);

      yield WeightHistoryLoadSucces(weights: weights);
    }
  }
}

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
    }
  }

  Stream<WeightHistoryState> _mapWeighHistoryLoadToState() async* {
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
}

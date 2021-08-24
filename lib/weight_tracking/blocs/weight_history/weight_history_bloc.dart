import 'dart:async';
import 'dart:developer';

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
  })  : _weightRepository = weightRepository,
        super(WeightHistoryLoading()) {
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
  mapEventToState(
    WeightHistoryEvent event,
  ) async* {
    if (event is WeightHistoryLoad) {
      yield* _mapWeighHistoryLoadToState();
    } else if (event is WeightHistoryAdded) {
      yield* _mapWeightHistoryAddedToState(event);
    } else if (event is WeightHistoryDelete) {
      yield* _mapWeightHistoryDeletedToState(event);
    } else if (event is WeightHistoryUpdated) {
      yield* _mapWeightHistoryUpdatedToState(event);
    }
  }

  Stream<WeightHistoryState> _mapWeighHistoryLoadToState() async* {
    if (state is WeightHistoryLoadSucces) {
      return;
    }

    if (!_isAuth) {
      yield WeightHistoryFailure();
      return;
    }
    try {
      yield WeightHistoryLoading();

      var weights = await _weightRepository.weightHistory(_userId!);

      yield WeightHistoryLoadSucces(weights: weights);
    } catch (error) {
      yield WeightHistoryFailure();
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryAddedToState(WeightHistoryAdded event) async* {
    if (_isAuth && state is WeightHistoryLoadSucces && event.weight != null) {
      final currentState = state as WeightHistoryLoadSucces;

      List<Weight> weights = currentState.weights;

      weights = weights..add(event.weight!);

      weights = weights..sort((a, b) => b.date!.compareTo(a.date!));

      yield WeightHistoryLoadSucces(weights: weights);
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryDeletedToState(WeightHistoryDelete event) async* {
    if (_isAuth && state is WeightHistoryLoadSucces && event.weight != null) {
      final currentState = state as WeightHistoryLoadSucces;

      List<Weight> weights = currentState.weights;

      weights.removeWhere((element) => element.id == event.weight!.id);

      yield WeightHistoryLoadSucces(weights: weights);
    }
  }

  Stream<WeightHistoryState> _mapWeightHistoryUpdatedToState(WeightHistoryUpdated event) async* {
    if (_isAuth && state is WeightHistoryLoadSucces && event.weight != null) {
      final currentState = state as WeightHistoryLoadSucces;

      List<Weight> weights = currentState.weights;

      weights = weights.map((e) {
        if (e.id == event.weight!.id) {
          return event.weight!;
        }
        return e;
      }).toList();

      yield WeightHistoryLoadSucces(weights: weights);
    }
  }
}

import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_goal_event.dart';
part 'weight_goal_state.dart';

class WeightGoalBloc extends Bloc<WeightGoalEvent, WeightGoalState> {
  WeightGoalBloc({
    required WeightRepository weightRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _authenticationBloc = authenticationBloc,
        _weightRepository = weightRepository,
        super(WeightGoalLoading());

  final WeightRepository _weightRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<WeightGoalState> mapEventToState(
    WeightGoalEvent event,
  ) async* {
    if (event is WeightGoalLoadEvent) {
      yield* _mapWeightGoalLoadToState();
    }
  }

  Stream<WeightGoalState> _mapWeightGoalLoadToState() async* {
    yield WeightGoalLoading();

    if (_authenticationBloc.state.status != AuthenticationStatus.authenticated) {
      return;
    }

    try {
      final WeightGoal? goal = await _weightRepository.getWeighGoal();

      if (goal == null) {
        yield WeightGoalFailure();
      }

      MeasurmentSystem measurmentSytem = _authenticationBloc.state.user!.measurmentSystem;
    } catch (error) {}
  }
}

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

  bool get isAuth => _authenticationBloc.state.isAuthenticated;
  User? get user => _authenticationBloc.state.user;

  @override
  Stream<WeightGoalState> mapEventToState(
    WeightGoalEvent event,
  ) async* {
    if (event is WeightGoalLoadEvent) {
      yield* _mapWeightGoalLoadToState();
    } else if (event is WeightGoalUpdated) {
      yield* _mapWeightGoalUpdatedToState(event);
    }
  }

  Stream<WeightGoalState> _mapWeightGoalLoadToState() async* {
    if (!isAuth) {
      yield WeightGoalFailure();
      return;
    }

    if (state is WeightGoalLoadSuccess) {
      return;
    }

    yield WeightGoalLoading();

    try {
      WeightGoal? goal = await _weightRepository.getWeighGoal(user!.id!);

      MeasurmentSystem system = _authenticationBloc.state.user!.measurmentSystem;

      if (goal == null) {
        yield WeightGoalLoading();
      } else {
        if (system == MeasurmentSystem.metric) {
          yield WeightGoalLoadSuccess(goal: goal);
        } else {
          yield WeightGoalLoadSuccess(
            goal: goal.copyWith(
              targetWeight: goal.targetWeight != null ? MeasurmentSystemConverter.kgToLb(goal.targetWeight!) : null,
              beginWeight: goal.beginWeight != null ? MeasurmentSystemConverter.kgToLb(goal.beginWeight!) : null,
              // weeklyGoal: MeasurmentSystemConverter.kgToLb(goal.weeklyGoal), //todo
            ),
          );
        }
      }
    } catch (error) {
      print('error' + error.toString());
      yield WeightGoalFailure();
    }
  }

  Stream<WeightGoalState> _mapWeightGoalUpdatedToState(WeightGoalUpdated event) async* {
    if (state is WeightGoalLoadSuccess) {
      if (event.weightGoal == null) return;

      yield WeightGoalLoadSuccess(goal: event.weightGoal!);
    }
  }
}

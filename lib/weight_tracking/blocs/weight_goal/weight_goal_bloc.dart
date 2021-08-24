import 'dart:async';

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
  })  : _weightRepository = weightRepository,
        super(WeightGoalLoading()) {
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

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
    if (!_isAuth) {
      yield WeightGoalFailure();
      return;
    }

    if (state is WeightGoalLoadSuccess) {
      return;
    }

    yield WeightGoalLoading();

    try {
      WeightGoal? goal = await _weightRepository.getWeighGoal(_userId!);

      if (goal == null) {
        yield WeightGoalLoading();
      } else {
        yield WeightGoalLoadSuccess(goal: goal);
      }
    } catch (error) {
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

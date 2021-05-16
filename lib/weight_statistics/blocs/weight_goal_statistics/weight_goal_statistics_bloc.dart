import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/weight_tracking/blocs/blocs.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_goal_statistics_event.dart';
part 'weight_goal_statistics_state.dart';

class WeightGoalStatisticsBloc extends Bloc<WeightGoalStatisticsEvent, WeightGoalStatisticsState> {
  WeightGoalStatisticsBloc({
    required WeightGoalBloc weightGoalBloc,
    required WeightRepository weightRepository,
    required WeightHistoryBloc weightHistoryBloc,
  })   : _weightGoalBloc = weightGoalBloc,
        _weightRepository = weightRepository,
        _weightHistoryBloc = weightHistoryBloc,
        super(WeightGoalStatisticsLoading()) {
    final goalState = _weightGoalBloc.state;

    if (goalState is WeightGoalLoadSuccess) {
      add(_WeightGoalUpdated(goalState.goal));
    } else {
      add(_WeightGoalFailure());
    }

    _weightGoalSubscripion = _weightGoalBloc.stream.listen(
      (goalState) {
        if (goalState is WeightGoalLoadSuccess) {
          add(_WeightGoalUpdated(goalState.goal));
        } else {
          add(_WeightGoalFailure());
        }
      },
    );

    final historyState = _weightHistoryBloc.state;

    if (historyState is WeightHistoryLoadSucces) {
      add(_WeightHistoryUpdated(historyState.weights));
    } else {
      add(_WeightHistoryFailure());
    }

    _weightHistorySubscription = _weightHistoryBloc.stream.listen(
      (historyState) {
        if (historyState is WeightHistoryLoadSucces) {
          add(_WeightHistoryUpdated(historyState.weights));
        } else {
          add(_WeightHistoryFailure());
        }
      },
    );
  }

  late final StreamSubscription _weightGoalSubscripion;
  late final StreamSubscription _weightHistorySubscription;
  final WeightHistoryBloc _weightHistoryBloc;
  final WeightGoalBloc _weightGoalBloc;
  final WeightRepository _weightRepository;

  @override
  Stream<WeightGoalStatisticsState> mapEventToState(
    WeightGoalStatisticsEvent event,
  ) async* {
    if (event is _WeightGoalUpdated) {
      yield* _mapGoalUpdatedToState(event);
    } else if (event is _WeightGoalFailure) {
      yield* _mapGoalFailureToState();
    } else if (event is _WeightHistoryFailure) {
      yield* _mapHistoryFailureToState();
    } else if (event is _WeightHistoryUpdated) {
      yield* _mapWeightHistoryUpdatedToState(event);
    }
  }

  Stream<WeightGoalStatisticsState> _mapGoalUpdatedToState(_WeightGoalUpdated event) async* {
    if (_weightHistoryBloc.state is WeightHistoryLoadSucces) {
      final historyState = _weightHistoryBloc.state as WeightHistoryLoadSucces;
      yield _calculateStatistics(historyState.weights, event.goal);
    }
  }

  Stream<WeightGoalStatisticsState> _mapWeightHistoryUpdatedToState(_WeightHistoryUpdated event) async* {
    if (_weightGoalBloc.state is WeightGoalLoadSuccess) {
      final goalState = _weightGoalBloc.state as WeightGoalLoadSuccess;
      yield _calculateStatistics(event.weights, goalState.goal);
    }
  }

  Stream<WeightGoalStatisticsState> _mapHistoryFailureToState() async* {
    yield (WeightGoalStatisticsFailure());
  }

  Stream<WeightGoalStatisticsState> _mapGoalFailureToState() async* {
    yield (WeightGoalStatisticsFailure());
  }

  WeightGoalStatisticsState _calculateStatistics(List<Weight> weights, WeightGoal goal) {
    double currentWeight = weights.first.weight?.toDouble() ?? 0.0;

    final percantageDone = _weightRepository.progressPercantage(
      current: currentWeight,
      starting: goal.beginWeight ?? 0,
      target: goal.targetWeight ?? 0,
    );

    final double remaining = _weightRepository.remaining(currentWeight, goal.targetWeight?.toDouble() ?? 0);

    return WeightGoalStatisticsLoadSuccess(
      percentageDone: percantageDone,
      remaining: remaining,
    );
  }

  @override
  Future<void> close() {
    _weightGoalSubscripion.cancel();
    _weightHistorySubscription.cancel();
    return super.close();
  }
}

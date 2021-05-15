import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:weight_repository/models/models.dart';
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

    _streamSubscription = _weightGoalBloc.stream.listen(
      (goalState) {
        if (goalState is WeightGoalLoadSuccess) {
          add(_WeightGoalUpdated(goalState.goal));
        } else {
          add(_WeightGoalFailure());
        }
      },
    );
  }

  late final StreamSubscription _streamSubscription;
  late final StreamSubscription _weightHistorySubscription;
  final WeightHistoryBloc _weightHistoryBloc;
  final WeightGoalBloc _weightGoalBloc;
  final WeightRepository _weightRepository;

  @override
  Stream<WeightGoalStatisticsState> mapEventToState(
    WeightGoalStatisticsEvent event,
  ) async* {
    if (event is _WeightGoalUpdated) {
      final percantageDone = _weightRepository.progressPercantage(
        current: 00,
        starting: event.goal.beginWeight ?? 0,
        target: event.goal.targetWeight ?? 0,
      );

      yield WeightGoalStatisticsLoadSuccess(
        percentageDone: percantageDone,
      );
    } else if (event is _WeightGoalFailure) {
      yield WeightGoalStatisticsFailure();
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

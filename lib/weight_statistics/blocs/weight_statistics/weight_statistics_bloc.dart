import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/weight_tracking/weight.dart' show WeightHistoryBloc, WeightHistoryLoadSucces;
import 'package:weight_repository/weight_repository.dart';

part 'weight_statistics_event.dart';
part 'weight_statistics_state.dart';

class WeightStatisticsBloc extends Bloc<WeightStatisticsEvent, WeightStatisticsState> {
  WeightStatisticsBloc({
    required WeightHistoryBloc weightHistoryBloc,
    required WeightRepository weightRepository,
  })   : _weightHistoryBloc = weightHistoryBloc,
        _weightRepository = weightRepository,
        super(WeightStatisticsLoading()) {
    if (_weightHistoryBloc.state is WeightHistoryLoadSucces) {
      add(_WeightHistoryUpdated(weights: (_weightHistoryBloc.state as WeightHistoryLoadSucces).weights));
    }

    _weightHistorySubscription = _weightHistoryBloc.stream.listen(
      (weightState) {
        if (weightState is WeightHistoryLoadSucces) {
          add(_WeightHistoryUpdated(weights: weightState.weights));
        }
      },
    );
  }

  final WeightHistoryBloc _weightHistoryBloc;
  late final StreamSubscription _weightHistorySubscription;
  final WeightRepository _weightRepository;

  @override
  Stream<WeightStatisticsState> mapEventToState(
    WeightStatisticsEvent event,
  ) async* {
    if (event is _WeightHistoryUpdated) {
      final double sevendDayChange = _weightRepository.weightChangeOnDuration(event.weights, const Duration(days: 7));
      final double thirdyDayChange = _weightRepository.weightChangeOnDuration(event.weights, const Duration(days: 30));
      final double totalChange = _weightRepository.totalWeightChange(event.weights);

      yield WeightStatisticsLoadedSuccessfully(
        sevenDayChange: sevendDayChange,
        thirdyDayChange: thirdyDayChange,
        totalChange: totalChange,
      );
    }
  }

  @override
  Future<void> close() async {
    _weightHistorySubscription.cancel();
    return super.close();
  }
}

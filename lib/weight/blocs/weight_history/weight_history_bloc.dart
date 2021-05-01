import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_repository/weight_repository.dart';

part 'weight_history_event.dart';
part 'weight_history_state.dart';

class WeightHistoryBloc extends Bloc<WeightHistoryEvent, WeightHistoryState> {
  WeightHistoryBloc() : super(WeightHistoryLoading());

  @override
  Stream<WeightHistoryState> mapEventToState(
    WeightHistoryEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

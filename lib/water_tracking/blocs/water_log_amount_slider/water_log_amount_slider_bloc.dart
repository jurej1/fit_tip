import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:water_repository/water_repository.dart';

part 'water_log_amount_slider_event.dart';
part 'water_log_amount_slider_state.dart';

class WaterLogAmountSliderBloc extends Bloc<WaterLogAmountSliderEvent, WaterLogAmountSliderState> {
  WaterLogAmountSliderBloc({
    required WaterLog log,
  }) : super(
          WaterLogAmountSliderState(
            currentAmount: log.cup.amount.toInt(),
            maxAmount: WaterCups.values.firstWhere((e) => e.size == log.cup.size).amount.toInt(),
            minAmount: 0,
          ),
        );

  @override
  Stream<WaterLogAmountSliderState> mapEventToState(
    WaterLogAmountSliderEvent event,
  ) async* {}
}

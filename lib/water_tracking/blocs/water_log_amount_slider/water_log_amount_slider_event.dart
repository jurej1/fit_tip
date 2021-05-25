part of 'water_log_amount_slider_bloc.dart';

abstract class WaterLogAmountSliderEvent extends Equatable {
  const WaterLogAmountSliderEvent();

  @override
  List<Object> get props => [];
}

class WaterLogSLiderUpdated extends WaterLogAmountSliderEvent {
  final double value;

  const WaterLogSLiderUpdated({required this.value});

  @override
  List<Object> get props => [value];
}

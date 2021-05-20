part of 'water_log_focused_day_bloc.dart';

abstract class WaterLogFocusedDayEvent extends Equatable {
  const WaterLogFocusedDayEvent();

  @override
  List<Object> get props => [];
}

class WaterLogNextDayPressed extends WaterLogFocusedDayEvent {}

class WaterLogPreviousDayPressed extends WaterLogFocusedDayEvent {}

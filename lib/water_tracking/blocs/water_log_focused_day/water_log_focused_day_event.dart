part of 'water_log_focused_day_bloc.dart';

abstract class WaterLogFocusedDayEvent extends Equatable {
  const WaterLogFocusedDayEvent();

  @override
  List<Object?> get props => [];
}

class WaterLogNextDayPressed extends WaterLogFocusedDayEvent {}

class WaterLogPreviousDayPressed extends WaterLogFocusedDayEvent {}

class WaterLogDatePicked extends WaterLogFocusedDayEvent {
  final DateTime? val;

  const WaterLogDatePicked(this.val);

  @override
  List<Object?> get props => [val];
}

part of 'water_log_day_bloc.dart';

abstract class WaterLogDayEvent extends Equatable {
  const WaterLogDayEvent();

  @override
  List<Object> get props => [];
}

class WaterLogFocusedDayUpdated extends WaterLogDayEvent {
  final DateTime dateTime;

  const WaterLogFocusedDayUpdated(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class WaterLogAddede extends WaterLogDayEvent {
  final WaterLog waterLog;

  const WaterLogAddede(this.waterLog);

  @override
  List<Object> get props => [waterLog];
}

class WaterLogRemoved extends WaterLogDayEvent {
  final WaterLog waterLog;

  const WaterLogRemoved(this.waterLog);

  @override
  List<Object> get props => [waterLog];
}

class WaterLogUpdated extends WaterLogDayEvent {
  final WaterLog waterLog;

  const WaterLogUpdated(this.waterLog);

  @override
  List<Object> get props => [waterLog];
}

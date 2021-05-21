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

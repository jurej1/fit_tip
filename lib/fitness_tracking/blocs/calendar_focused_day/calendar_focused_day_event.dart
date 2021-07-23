part of 'calendar_focused_day_bloc.dart';

abstract class CalendarFocusedDayEvent extends Equatable {
  const CalendarFocusedDayEvent();

  @override
  List<Object> get props => [];
}

class CalendarFocusedDayUpdated extends CalendarFocusedDayEvent {
  final DateTime value;

  const CalendarFocusedDayUpdated(this.value);

  @override
  List<Object> get props => [value];
}

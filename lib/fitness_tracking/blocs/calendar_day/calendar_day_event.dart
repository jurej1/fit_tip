part of 'calendar_day_bloc.dart';

abstract class CalendarDayEvent extends Equatable {
  const CalendarDayEvent();

  @override
  List<Object> get props => [];
}

class CalendarDaySelectedDayUpdated extends CalendarDayEvent {
  final DateTime date;

  const CalendarDaySelectedDayUpdated(this.date);
  @override
  List<Object> get props => [date];
}

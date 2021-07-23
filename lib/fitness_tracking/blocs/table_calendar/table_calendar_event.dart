part of 'table_calendar_bloc.dart';

abstract class TableCalendarEvent extends Equatable {
  const TableCalendarEvent();

  @override
  List<Object> get props => [];
}

class TableCalendarFocusedDayUpdated extends TableCalendarEvent {
  final DateTime value;

  const TableCalendarFocusedDayUpdated(this.value);
  @override
  List<Object> get props => [value];
}

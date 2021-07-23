part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarModeButtonPressed extends CalendarEvent {}

class CalendarFocusedDateUpdated extends CalendarEvent {
  final DateTime dateTime;

  const CalendarFocusedDateUpdated(this.dateTime);
  @override
  List<Object> get props => [dateTime];
}

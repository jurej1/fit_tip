part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarModeButtonPressed extends CalendarEvent {}

class CalendarPageChanged extends CalendarEvent {
  final int value;

  const CalendarPageChanged(this.value);
  @override
  List<Object> get props => [value];
}

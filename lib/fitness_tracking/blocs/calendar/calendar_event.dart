part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarModeButtonPressed extends CalendarEvent {}

class CalendarScrollEndNotification extends CalendarEvent {
  final ScrollEndNotification notification;

  const CalendarScrollEndNotification(this.notification);

  @override
  List<Object> get props => [notification];
}

class CalendarScrollUpdateNotification extends CalendarEvent {
  final ScrollUpdateNotification notification;

  const CalendarScrollUpdateNotification(this.notification);
  @override
  List<Object> get props => [notification];
}

class CalendarListSnapped extends CalendarEvent {}

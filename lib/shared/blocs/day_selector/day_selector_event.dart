part of 'day_selector_bloc.dart';

abstract class DaySelectorEvent extends Equatable {
  const DaySelectorEvent();

  @override
  List<Object?> get props => [];
}

class DaySelectorPreviousDayRequested extends DaySelectorEvent {}

class DaySelectorNextDayRequested extends DaySelectorEvent {}

class DaySelectorDatePicked extends DaySelectorEvent {
  final DateTime? date;

  const DaySelectorDatePicked(this.date);

  @override
  List<Object?> get props => [date];
}

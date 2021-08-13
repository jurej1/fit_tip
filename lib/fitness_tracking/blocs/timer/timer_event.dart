part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStart extends TimerEvent {}

class _TimerUpdated extends TimerEvent {}

class TimerStop extends TimerEvent {}

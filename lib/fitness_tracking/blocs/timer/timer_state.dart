part of 'timer_bloc.dart';

class TimerState extends Equatable {
  const TimerState(this.duration);
  final Duration duration;

  @override
  List<Object> get props => [duration];

  TimerState copyWith({
    Duration? duration,
  }) {
    return TimerState(
      duration ?? this.duration,
    );
  }
}

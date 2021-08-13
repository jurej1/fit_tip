part of 'timer_bloc.dart';

class TimerState extends Equatable {
  const TimerState(this.duration, this.isInit);
  final Duration duration;
  final bool isInit;
  @override
  List<Object> get props => [duration];

  int get hours => this.duration.inHours.remainder(24).toInt();
  int get minutes => this.duration.inMinutes.remainder(60).toInt();
  int get seconds => this.duration.inSeconds.remainder(60).toInt();

  TimerState copyWith({
    Duration? duration,
    bool? isInit,
  }) {
    return TimerState(
      duration ?? this.duration,
      isInit ?? this.isInit,
    );
  }
}

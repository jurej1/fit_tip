import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc()
      : super(
          TimerState(Duration.zero, false),
        );

  final int _milliseconds = 1000;
  late final Timer _timer;

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStart) {
      yield* _mapTimerStartToState();
    } else if (event is _TimerUpdated) {
      yield* _mapTimerUpdatedToState();
    } else if (event is TimerStop) {
      yield* _mapTimerStopToState();
    }
  }

  Stream<TimerState> _mapTimerStartToState() async* {
    if (!state.isInit) {
      _timer = Timer.periodic(Duration(milliseconds: _milliseconds), (timer) {
        add(_TimerUpdated());
      });
    }
  }

  Stream<TimerState> _mapTimerUpdatedToState() async* {
    // if (_timer.isActive) {
    //   yield state.copyWith(
    //     duration: Duration(
    //       milliseconds: state.duration.inMilliseconds + _milliseconds,
    //     ),
    //     isInit: true,
    //   );
    // }
  }

  Stream<TimerState> _mapTimerStopToState() async* {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}

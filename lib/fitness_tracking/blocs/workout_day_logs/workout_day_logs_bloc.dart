import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/blocs/active_workout_bloc/active_workout_bloc.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_day_logs_event.dart';
part 'workout_day_logs_state.dart';

class WorkoutDayLogsBloc extends Bloc<WorkoutDayLogsEvent, WorkoutDayLogsState> {
  WorkoutDayLogsBloc({
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
    required ActiveWorkoutBloc activeWorkoutBloc,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(WorkoutDayLogsLoading()) {
    if (activeWorkoutBloc.state is ActiveWorkoutLoadSuccess) {
      add(_WorkoutDayLogsWorkoutUpdated((activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout));
    }

    _streamSubscription = activeWorkoutBloc.stream.listen((activeState) {
      if (activeWorkoutBloc.state is ActiveWorkoutLoadSuccess) {
        add(_WorkoutDayLogsWorkoutUpdated((activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout));
      }
    });
  }

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  late final StreamSubscription _streamSubscription;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<WorkoutDayLogsState> mapEventToState(
    WorkoutDayLogsEvent event,
  ) async* {
    if (event is _WorkoutDayLogsWorkoutUpdated) {
      yield* _mapWorkoutUpdatedToState(event);
    } else if (event is WorkoutDayLogsLogAdded) {
      yield* _mapLogAddedToState(event);
    } else if (event is WorkoutDayLogsLogRemoved) {
      yield* _mapLogRemovedToState(event);
    } else if (event is WorkoutDayLogsLogUpdated) {
      yield* _mapLogUpdatedToState(event);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  Stream<WorkoutDayLogsState> _mapWorkoutUpdatedToState(_WorkoutDayLogsWorkoutUpdated event) async* {
    if (_isAuth) {
      yield WorkoutDayLogsLoading();

      try {
        List<WorkoutDayLog>? logs = await _fitnessRepository.getWorkoutDayLogByWorkoutId(_user!.id!, event.workout.id);

        if (logs != null) {
          yield WorkoutDayLogsLoadSuccess(logs);
        } else {
          yield WorkoutDayLogsLoadSuccess();
        }
      } catch (error) {}
    } else {
      yield WorkoutDayLogsFailure();
    }
  }

  Stream<WorkoutDayLogsState> _mapLogAddedToState(WorkoutDayLogsLogAdded event) async* {
    if (state is WorkoutDayLogsLoadSuccess) {
      final currentState = state as WorkoutDayLogsLoadSuccess;

      if (currentState.logs.isEmpty) {
        yield WorkoutDayLogsLoadSuccess([event.log]);
      } else {
        List<WorkoutDayLog> logs = currentState.logs;

        logs.add(event.log);
        logs.sort((a, b) => b.created.compareTo(a.created));

        yield WorkoutDayLogsLoadSuccess(logs);
      }
    }
  }

  Stream<WorkoutDayLogsState> _mapLogRemovedToState(WorkoutDayLogsLogRemoved event) async* {
    if (state is WorkoutDayLogsLoadSuccess) {
      final currentState = state as WorkoutDayLogsLoadSuccess;
      List<WorkoutDayLog> logs = currentState.logs;
      logs.removeWhere((element) => element.id == event.log.id);
      yield WorkoutDayLogsLoadSuccess(logs);
    }
  }

  Stream<WorkoutDayLogsState> _mapLogUpdatedToState(WorkoutDayLogsLogUpdated event) async* {
    if (state is WorkoutDayLogsLoadSuccess) {
      final currentState = state as WorkoutDayLogsLoadSuccess;
      List<WorkoutDayLog> logs = currentState.logs;
      logs = logs.map((e) {
        if (e.id == event.log.id) {
          return event.log;
        }
        return e;
      }).toList();
      yield WorkoutDayLogsLoadSuccess(logs);
    }
  }
}

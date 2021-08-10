import 'dart:async';
import 'dart:developer';

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
        _activeWorkoutBloc = activeWorkoutBloc,
        super(WorkoutDayLogsLoading());

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;
  final ActiveWorkoutBloc _activeWorkoutBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<WorkoutDayLogsState> mapEventToState(
    WorkoutDayLogsEvent event,
  ) async* {
    if (event is WorkoutDayLogsLoadRequested) {
      yield* _mapWorkoutUpdatedToState();
    } else if (event is WorkoutDayLogsLogAdded) {
      yield* _mapLogAddedToState(event);
    } else if (event is WorkoutDayLogsLogRemoved) {
      yield* _mapLogRemovedToState(event);
    } else if (event is WorkoutDayLogsLogUpdated) {
      yield* _mapLogUpdatedToState(event);
    }
  }

  Stream<WorkoutDayLogsState> _mapWorkoutUpdatedToState() async* {
    if (state is WorkoutDayLogsLoadSuccess) return;

    if (_isAuth && _activeWorkoutBloc.state is ActiveWorkoutLoadSuccess) {
      yield WorkoutDayLogsLoading();

      try {
        List<WorkoutDayLog>? logs = await _fitnessRepository.getWorkoutDayLogByWorkoutId(
          _user!.id!,
          (_activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.id,
        );

        if (logs != null) {
          yield WorkoutDayLogsLoadSuccess(logs);
        } else {
          yield WorkoutDayLogsLoadSuccess();
        }
      } catch (error) {
        log(error.toString());
        yield WorkoutDayLogsFailure();
      }
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

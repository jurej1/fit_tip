import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        _activeWorkoutBloc = activeWorkoutBloc,
        _authenticationBloc = authenticationBloc,
        super(WorkoutDayLogsLoading());

  final FitnessRepository _fitnessRepository;
  final ActiveWorkoutBloc _activeWorkoutBloc;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<WorkoutDayLogsState> mapEventToState(
    WorkoutDayLogsEvent event,
  ) async* {
    if (event is WorkoutDayLogsLoadRequested) {
      yield* _mapLoadRequestedToState();
    } else if (event is WorkoutDayLogsLogAdded) {
      yield* _mapLogAddedToState(event);
    } else if (event is WorkoutDayLogsLogRemoved) {
      yield* _mapLogRemovedToState(event);
    } else if (event is WorkoutDayLogsLogUpdated) {
      yield* _mapLogUpdatedToState(event);
    }
  }

  Stream<WorkoutDayLogsState> _mapLoadRequestedToState() async* {
    if (state is WorkoutDayLogsLoadSuccess) return;

    if (_authenticationBloc.state.isAuthenticated && _activeWorkoutBloc.state is ActiveWorkoutLoadSuccess) {
      yield WorkoutDayLogsLoading();

      try {
        QuerySnapshot snapshots = await _fitnessRepository.getWorkoutDayLogByWorkoutId(
          _authenticationBloc.state.user!.uid!,
          (_activeWorkoutBloc.state as ActiveWorkoutLoadSuccess).workout.info.id,
        );

        List<WorkoutDayLog> logs = snapshots.docs
            .map(
              (e) => WorkoutDayLog.fromEntity(
                WorkoutDayLogEntity.fromDocumentSnapshot(e),
              ),
            )
            .toList();

        yield WorkoutDayLogsLoadSuccess(logs);
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

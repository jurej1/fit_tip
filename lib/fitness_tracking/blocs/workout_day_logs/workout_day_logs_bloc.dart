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
}

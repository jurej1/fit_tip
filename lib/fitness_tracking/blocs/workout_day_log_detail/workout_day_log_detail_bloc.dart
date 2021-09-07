import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workout_day_log_detail_event.dart';
part 'workout_day_log_detail_state.dart';

class WorkoutDayLogDetailBloc extends Bloc<WorkoutDayLogDetailEvent, WorkoutDayLogDetailState> {
  WorkoutDayLogDetailBloc({
    required WorkoutDayLog dayLog,
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : this._fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(WorkoutDayLogDetailInitial(dayLog));

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<WorkoutDayLogDetailState> mapEventToState(
    WorkoutDayLogDetailEvent event,
  ) async* {
    if (event is WorkoutDayLogDetailDeleteRequested) {
      yield* _mapDeleteRequestedToState();
    }
  }

  Stream<WorkoutDayLogDetailState> _mapDeleteRequestedToState() async* {
    if (_authenticationBloc.state.isAuthenticated) {
      yield WorkoutDayLogDetailLoading(state.dayLog);

      try {
        await _fitnessRepository.deleteWorkoutDayLog(state.dayLog);
        yield WorkoutDayLogDetailDeleteSuccess(state.dayLog);
      } catch (error) {
        yield WorkoutDayLogDetailFail(state.dayLog);
      }
    }
  }
}

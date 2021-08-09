import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'running_workout_day_event.dart';
part 'running_workout_day_state.dart';

class RunningWorkoutDayBloc extends Bloc<RunningWorkoutDayEvent, RunningWorkoutDayState> {
  RunningWorkoutDayBloc({
    required WorkoutDay workoutDay,
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
    required DateTime date,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(
          RunningWorkoutDayInitial(workoutDay: workoutDay, date: date, pageViewIndex: 0),
        );

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<RunningWorkoutDayState> mapEventToState(
    RunningWorkoutDayEvent event,
  ) async* {
    if (event is RunningWorkoutDayPageIndexUpdated) {
      yield RunningWorkoutDayInitial(pageViewIndex: event.value, workoutDay: state.workoutDay, date: state.date);
    } else if (event is RunningWorkoutDayWorkoutExcerciseUpdated) {
      yield* _mapExcerciseUpdatetToState(event);
    } else if (event is RunningWorkoutDayWorkoutExcerciseSubmit) {
      yield* _mapExcerciseSubmitToState(event);
    }
  }

  Stream<RunningWorkoutDayState> _mapExcerciseUpdatetToState(RunningWorkoutDayWorkoutExcerciseUpdated event) async* {
    WorkoutDay workoutDay = this.state.workoutDay;
    List<WorkoutExcercise> excercises = workoutDay.excercises;

    excercises = excercises.map((e) {
      if (e.id == event.excercise.id) return event.excercise;
      return e;
    }).toList();

    yield RunningWorkoutDayInitial(
        workoutDay: workoutDay.copyWith(excercises: excercises), date: state.date, pageViewIndex: state.pageViewIndex);
  }

  Stream<RunningWorkoutDayState> _mapExcerciseSubmitToState(RunningWorkoutDayWorkoutExcerciseSubmit event) async* {
    if (_isAuth) {
      try {
        yield RunningWorkoutDayLoading(workoutDay: state.workoutDay, pageViewIndex: state.pageViewIndex, date: state.date);

        // _fitnessRepository.addWorkoutLog(_user!.id!, workout, dateLogged);
      } catch (error) {}
    } else {
      yield RunningWorkoutDayFailure(workoutDay: state.workoutDay, pageViewIndex: state.pageViewIndex, date: state.date);
    }
  }
}

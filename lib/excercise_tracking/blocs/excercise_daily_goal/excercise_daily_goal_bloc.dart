import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'excercise_daily_goal_event.dart';
part 'excercise_daily_goal_state.dart';

class ExcerciseDailyGoalBloc extends Bloc<ExcerciseDailyGoalEvent, ExcerciseDailyGoalState> {
  ExcerciseDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required FitnessRepository fitnessRepository,
  })  : _fitnessRepository = fitnessRepository,
        _authenticationBloc = authenticationBloc,
        super(ExcerciseDailyGoalLoading());

  final AuthenticationBloc _authenticationBloc;
  final FitnessRepository _fitnessRepository;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<ExcerciseDailyGoalState> mapEventToState(
    ExcerciseDailyGoalEvent event,
  ) async* {
    if (event is ExcerciseDailyGoalDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is ExcerciseDailyGoalUpdated) {
      yield* _mapGoalUpdatedToState(event);
    }
  }

  Stream<ExcerciseDailyGoalState> _mapDateUpdatedToState(ExcerciseDailyGoalDateUpdated event) async* {
    if (this.state is ExcerciseDailyGoalLoadSuccess) {
      final current = state as ExcerciseDailyGoalLoadSuccess;

      final goalDate = current.goal.date;
      final eventDate = event.date;
      final a = DateTime(goalDate.year, goalDate.month, goalDate.day);
      final b = DateTime(eventDate.year, eventDate.month, eventDate.day);

      if (a == b) return;
    }

    if (_isAuth) {
      yield ExcerciseDailyGoalLoading();

      try {
        ExcerciseDailyGoal goal = await _fitnessRepository.getExcerciseDailyGoal(_user!.id!, event.date);

        yield ExcerciseDailyGoalLoadSuccess(goal);
      } on Exception catch (e) {
        yield ExcerciseDailyGoalFailure(e.toString());
      }
    }
  }

  Stream<ExcerciseDailyGoalState> _mapGoalUpdatedToState(ExcerciseDailyGoalUpdated event) async* {
    if (_isAuth && state is ExcerciseDailyGoalLoadSuccess) {
      yield ExcerciseDailyGoalLoadSuccess(event.goal);
    }
  }
}

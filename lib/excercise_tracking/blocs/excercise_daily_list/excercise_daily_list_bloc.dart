import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';

part 'excercise_daily_list_event.dart';
part 'excercise_daily_list_state.dart';

class ExcerciseDailyListBloc extends Bloc<ExcerciseDailyListEvent, ExcerciseDailyListState> {
  ExcerciseDailyListBloc({
    required ActivityRepository activityRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _activityRepository = activityRepository,
        _authenticationBloc = authenticationBloc,
        super(ExcerciseDailyListLoading());

  final ActivityRepository _activityRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<ExcerciseDailyListState> mapEventToState(
    ExcerciseDailyListEvent event,
  ) async* {
    if (event is ExcerciseDailyListDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is ExcerciseDailyListLogUpdated) {
      yield* _mapLogUpdatedToState(event);
    } else if (event is ExcerciseDailyListLogAdded) {
      yield* _mapLogAddedToState(event);
    } else if (event is ExcerciseDailyListLogRemoved) {
      yield* _mapLogRemovedToState(event);
    }
  }

  Stream<ExcerciseDailyListState> _mapDateUpdatedToState(ExcerciseDailyListDateUpdated event) async* {
    if (!_isAuth) {
      yield ExcerciseDailyListFailure();
      return;
    }
    yield ExcerciseDailyListLoading();

    try {
      QuerySnapshot snapshot = await _activityRepository.getExcerciseLogsForDay(_user!.id!, event.date);

      yield ExcerciseDailyListLoadSuccess(ExcerciseLog.fromQuerySnapshot(snapshot));
    } catch (error) {
      yield ExcerciseDailyListFailure();
    }
  }

  Stream<ExcerciseDailyListState> _mapLogAddedToState(ExcerciseDailyListLogAdded event) async* {
    if (state is ExcerciseDailyListLoadSuccess && event.log != null && _isAuth) {
      List<ExcerciseLog> logs = (state as ExcerciseDailyListLoadSuccess).excercises;

      if (logs.isEmpty) {
        logs.add(event.log!);
      } else {
        logs.insert(0, event.log!);
      }

      print('item added: ${logs}');

      yield ExcerciseDailyListLoadSuccess(logs);
    }
  }

  Stream<ExcerciseDailyListState> _mapLogUpdatedToState(ExcerciseDailyListLogUpdated event) async* {
    if (state is ExcerciseDailyListLoadSuccess && event.log != null && _isAuth) {
      List<ExcerciseLog> logs = (state as ExcerciseDailyListLoadSuccess).excercises;

      logs.map((e) {
        if (e.id == event.log!.id) {
          return event.log!;
        }

        return e;
      });

      yield ExcerciseDailyListLoadSuccess(logs);
    }
  }

  Stream<ExcerciseDailyListState> _mapLogRemovedToState(ExcerciseDailyListLogRemoved event) async* {
    if (state is ExcerciseDailyListLoadSuccess && event.log != null && _isAuth) {
      List<ExcerciseLog> logs = (state as ExcerciseDailyListLoadSuccess).excercises;

      logs.remove(event.log!);

      yield ExcerciseDailyListLoadSuccess(logs);
    }
  }
}

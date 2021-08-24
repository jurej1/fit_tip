import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'excercise_daily_list_event.dart';
part 'excercise_daily_list_state.dart';

class ExcerciseDailyListBloc extends Bloc<ExcerciseDailyListEvent, ExcerciseDailyListState> {
  ExcerciseDailyListBloc({
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _fitnessRepository = fitnessRepository,
        super(ExcerciseDailyListLoading()) {
    final authState = authenticationBloc.state;

    _userId = authState.user?.uid;
    _isAuth = authState.isAuthenticated;

    _authSubscription = authenticationBloc.stream.listen((event) {
      add(ExcerciseDailyListDateUpdated(DateTime.now()));

      _userId = event.user?.uid;
      _isAuth = event.isAuthenticated;
    });
  }

  final FitnessRepository _fitnessRepository;
  late final StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

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
      QuerySnapshot snapshot = await _fitnessRepository.getExcerciseLogsForDay(_userId!, event.date);

      yield ExcerciseDailyListLoadSuccess(ExcerciseLog.fromQuerySnapshot(snapshot));
    } catch (error) {
      log(error.toString());
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

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

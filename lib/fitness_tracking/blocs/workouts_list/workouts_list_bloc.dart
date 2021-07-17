import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'workouts_list_event.dart';
part 'workouts_list_state.dart';

class WorkoutsListBloc extends Bloc<WorkoutsListEvent, WorkoutsListState> {
  WorkoutsListBloc({
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        _fitnessRepository = fitnessRepository,
        super(WorkoutsListLoading());

  final FitnessRepository _fitnessRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<WorkoutsListState> mapEventToState(
    WorkoutsListEvent event,
  ) async* {
    if (event is WorkoutListLoadRequested) {
      yield* _mapLoadRequestToState();
    }
  }

  Stream<WorkoutsListState> _mapLoadRequestToState() async* {
    if (!_isAuth) {
      yield WorkoutsListFail();
      return;
    }
    yield WorkoutsListLoading();

    try {
      QuerySnapshot querySnapshot = await _fitnessRepository.getWorkouts(_user!.id!);

      List<Workout> workouts = Workout.fromQuerySnapshot(querySnapshot);

      yield WorkoutsListLoadSuccess(workouts);
    } catch (e) {
      yield WorkoutsListFail();
    }
  }
}

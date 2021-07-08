import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';

part 'excercise_tile_event.dart';
part 'excercise_tile_state.dart';

class ExcerciseTileBloc extends Bloc<ExcerciseTileEvent, ExcerciseTileState> {
  ExcerciseTileBloc({
    required ExcerciseLog excerciseLog,
    required FitnessRepository fitnessRepository,
    required AuthenticationBloc authenticationBloc,
  })  : this._activityRepository = fitnessRepository,
        this._authenticationBloc = authenticationBloc,
        super(ExcerciseTileInitial(excerciseLog, false));

  final FitnessRepository _activityRepository;
  final AuthenticationBloc _authenticationBloc;

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<ExcerciseTileState> mapEventToState(
    ExcerciseTileEvent event,
  ) async* {
    if (event is ExcerciseTilePressed) {
      yield ExcerciseTileInitial(state.excerciseLog, !state.isExpanded);
    } else if (event is ExcerciseTileDeleteRequested) {
      yield* _mapDeleteToState();
    }
  }

  Stream<ExcerciseTileState> _mapDeleteToState() async* {
    if (_isAuth) {
      yield ExcerciseTileLoading(state.excerciseLog, false);

      try {
        await _activityRepository.deleteExcerciseLog(_user!.id!, state.excerciseLog);

        yield ExcerciseTileDeleteSuccess(state.excerciseLog, false);
      } on Exception catch (e) {
        yield ExcerciseTileDeleteFail(state.excerciseLog, false, errorMsg: e.toString());
      }
    }
  }
}

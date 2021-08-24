import 'dart:async';

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
        super(ExcerciseTileInitial(excerciseLog, false)) {
    final authState = authenticationBloc.state;
    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authenticationSubscription = authenticationBloc.stream.listen((event) {
      _isAuth = event.isAuthenticated;
      _userId = event.user?.uid;
    });
  }

  final FitnessRepository _activityRepository;
  late final StreamSubscription _authenticationSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authenticationSubscription.cancel();
    return super.close();
  }

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
        await _activityRepository.deleteExcerciseLog(_userId!, state.excerciseLog);

        yield ExcerciseTileDeleteSuccess(state.excerciseLog, false);
      } on Exception catch (e) {
        yield ExcerciseTileDeleteFail(state.excerciseLog, false, errorMsg: e.toString());
      }
    }
  }
}

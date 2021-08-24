import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
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
        super(WorkoutDayLogDetailInitial(dayLog)) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final FitnessRepository _fitnessRepository;
  late StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<WorkoutDayLogDetailState> mapEventToState(
    WorkoutDayLogDetailEvent event,
  ) async* {
    if (event is WorkoutDayLogDetailDeleteRequested) {
      yield* _mapDeleteRequestedToState();
    }
  }

  Stream<WorkoutDayLogDetailState> _mapDeleteRequestedToState() async* {
    if (_isAuth) {
      yield WorkoutDayLogDetailLoading(state.dayLog);

      try {
        await _fitnessRepository.deleteWorkoutDayLog(_userId!, state.dayLog);
        yield WorkoutDayLogDetailDeleteSuccess(state.dayLog);
      } catch (error) {
        yield WorkoutDayLogDetailFail(state.dayLog);
      }
    }
  }
}

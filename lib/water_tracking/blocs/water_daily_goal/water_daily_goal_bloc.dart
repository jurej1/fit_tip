import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart' as rep;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:water_repository/water_repository.dart';

part 'water_daily_goal_event.dart';
part 'water_daily_goal_state.dart';

class WaterDailyGoalBloc extends Bloc<WaterDailyGoalEvent, WaterDailyGoalState> {
  WaterDailyGoalBloc({
    required AuthenticationBloc authenticationBloc,
    required WaterRepository waterRepository,
  })   : _authenticationBloc = authenticationBloc,
        _waterRepository = waterRepository,
        super(WaterDailyGoalLoading());

  final AuthenticationBloc _authenticationBloc;
  final WaterRepository _waterRepository;

  @override
  Stream<WaterDailyGoalState> mapEventToState(
    WaterDailyGoalEvent event,
  ) async* {
    if (event is WaterDailyGoalDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    }
  }

  Stream<WaterDailyGoalState> _mapDateUpdatedToState(WaterDailyGoalDateUpdated event) async* {
    if (!_authenticationBloc.state.isAuthenticated) {
      yield WaterDailyGoalFailure('');
      return;
    }

    yield WaterDailyGoalLoading();

    try {
      final rep.User user = _authenticationBloc.state.user!;

      WaterDailyGoal goal = (await _waterRepository.getWaterGoal(user.id!, event.date));
    } catch (error) {}
  }
}

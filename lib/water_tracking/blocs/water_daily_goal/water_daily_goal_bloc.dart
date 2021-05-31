import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
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

  bool get _isAuth => _authenticationBloc.state.isAuthenticated;
  User? get _user => _authenticationBloc.state.user;

  @override
  Stream<WaterDailyGoalState> mapEventToState(
    WaterDailyGoalEvent event,
  ) async* {
    if (event is WaterDailyGoalDateUpdated) {
      yield* _mapDateUpdatedToState(event);
    } else if (event is WaterDailyGoalAmountUpdated) {
      yield* _mapAmountUpdatedToState(event);
    }
  }

  Stream<WaterDailyGoalState> _mapDateUpdatedToState(WaterDailyGoalDateUpdated event) async* {
    if (!_isAuth) {
      yield WaterDailyGoalFailure('');
      return;
    }

    yield WaterDailyGoalLoading();

    try {
      WaterDailyGoal goal = await _waterRepository.getWaterDailyGoal(_user!.id!, date: event.date);

      yield WaterDailyGoalLoadSuccess(goal);
    } catch (error) {
      print('error' + error.toString());

      yield WaterDailyGoalFailure('');
    }
  }

  Stream<WaterDailyGoalState> _mapAmountUpdatedToState(WaterDailyGoalAmountUpdated event) async* {
    if (state is WaterDailyGoalLoadSuccess) {
      final goal = (state as WaterDailyGoalLoadSuccess).goal;

      yield WaterDailyGoalLoadSuccess(goal.copyWith(amount: event.amount));
    }
  }
}

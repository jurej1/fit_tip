import 'dart:async';
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
  })  : _waterRepository = waterRepository,
        super(WaterDailyGoalLoading()) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final WaterRepository _waterRepository;
  late final StreamSubscription _authSubscription;

  bool _isAuth = false;
  String? _userId;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

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
      WaterDailyGoal goal = await _waterRepository.getWaterDailyGoal(_userId!, date: event.date);

      yield WaterDailyGoalLoadSuccess(goal);
    } catch (error) {
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

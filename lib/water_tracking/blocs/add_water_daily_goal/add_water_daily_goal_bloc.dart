import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/blocs/blocs.dart';
import 'package:fit_tip/water_tracking/models/models.dart';
import 'package:formz/formz.dart';
import 'package:water_repository/water_repository.dart';

part 'add_water_daily_goal_event.dart';
part 'add_water_daily_goal_state.dart';

class AddWaterDailyGoalBloc extends Bloc<AddWaterDailyGoalEvent, AddWaterDailyGoalState> {
  AddWaterDailyGoalBloc({
    required WaterRepository waterRepository,
    required AuthenticationBloc authenticationBloc,
    required DaySelectorBloc waterLogFocusedDayBloc,
    required WaterDailyGoalBloc waterDailyGoalBloc,
  })  : _waterRepository = waterRepository,
        _waterLogFocusedDayBloc = waterLogFocusedDayBloc,
        super(
          AddWaterDailyGoalState(
            amount: (waterDailyGoalBloc.state is WaterDailyGoalLoadSuccess)
                ? WaterGoalAmount.pure(
                    (waterDailyGoalBloc.state as WaterDailyGoalLoadSuccess).goal.amount.toStringAsFixed(0),
                  )
                : WaterGoalAmount.pure(),
          ),
        ) {
    final authState = authenticationBloc.state;

    _isAuth = authState.isAuthenticated;
    _userId = authState.user?.uid;

    _authSubscription = authenticationBloc.stream.listen((authState) {
      _isAuth = authState.isAuthenticated;
      _userId = authState.user?.uid;
    });
  }

  final DaySelectorBloc _waterLogFocusedDayBloc;
  final WaterRepository _waterRepository;
  late final StreamSubscription _authSubscription;

  String? _userId;
  bool _isAuth = false;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AddWaterDailyGoalState> mapEventToState(
    AddWaterDailyGoalEvent event,
  ) async* {
    if (event is AddWaterDailyGoalAmountChanged) {
      yield _mapAmountChangedToState(event);
    } else if (event is AddWaterDailyGoalFormSubmit) {
      yield* _mapFormSubmitToState();
    }
  }

  AddWaterDailyGoalState _mapAmountChangedToState(AddWaterDailyGoalAmountChanged event) {
    final amount = WaterGoalAmount.dirty(event.value);

    return state.copyWith(
      status: Formz.validate([amount]),
      amount: amount,
    );
  }

  Stream<AddWaterDailyGoalState> _mapFormSubmitToState() async* {
    final amount = WaterGoalAmount.dirty(state.amount.value);

    yield state.copyWith(
      amount: amount,
      status: Formz.validate([amount]),
    );

    if (state.status.isValidated && _isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final DateTime date = _waterLogFocusedDayBloc.state.selectedDate;
        await _waterRepository.addWaterGoal(
          _userId!,
          WaterDailyGoal(
            amount: double.parse(state.amount.value),
            id: WaterDailyGoal.generateId(date),
            date: date,
          ),
        );

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } catch (error) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMsg: error.toString(),
        );
      }
    }
  }
}

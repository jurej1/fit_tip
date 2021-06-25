import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart' as rep;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
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
    required WaterLogFocusedDayBloc waterLogFocusedDayBloc,
    required WaterDailyGoalBloc waterDailyGoalBloc,
  })   : _waterRepository = waterRepository,
        _authenticationBloc = authenticationBloc,
        _waterLogFocusedDayBloc = waterLogFocusedDayBloc,
        super(
          AddWaterDailyGoalState(
            amount: (waterDailyGoalBloc.state is WaterDailyGoalLoadSuccess)
                ? WaterGoalAmount.pure(
                    (waterDailyGoalBloc.state as WaterDailyGoalLoadSuccess).goal.amount.toStringAsFixed(0),
                  )
                : WaterGoalAmount.pure(),
          ),
        );

  final WaterLogFocusedDayBloc _waterLogFocusedDayBloc;
  final WaterRepository _waterRepository;
  final AuthenticationBloc _authenticationBloc;

  rep.User? get user => _authenticationBloc.state.user;
  bool get isAuth => _authenticationBloc.state.isAuthenticated;

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

    if (state.status.isValidated && isAuth) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final DateTime date = _waterLogFocusedDayBloc.state.selectedDate;
        await _waterRepository.addWaterGoal(
          user!.id!,
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

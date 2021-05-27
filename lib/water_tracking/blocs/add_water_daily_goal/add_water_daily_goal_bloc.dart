import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/water_tracking/models/models.dart';
import 'package:formz/formz.dart';
import 'package:water_repository/water_repository.dart';

part 'add_water_daily_goal_event.dart';
part 'add_water_daily_goal_state.dart';

class AddWaterDailyGoalBloc extends Bloc<AddWaterDailyGoalEvent, AddWaterDailyGoalState> {
  AddWaterDailyGoalBloc({
    required WaterRepository waterRepository,
    required AuthenticationBloc authenticationBloc,
  })   : _waterRepository = waterRepository,
        _authenticationBloc = authenticationBloc,
        super(AddWaterDailyGoalState());

  final WaterRepository _waterRepository;
  final AuthenticationBloc _authenticationBloc;

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

    if (state.status.isValidated && _authenticationBloc.state.isAuthenticated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final DateTime date = DateTime.now();
        await _waterRepository.addWaterGoal(
          WaterGoalDaily(
            amount: double.parse(state.amount.value),
            id: WaterGoalDaily.generateId(date),
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

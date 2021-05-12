import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_tip/weight_tracking/models/models.dart' as models;
import 'package:formz/formz.dart';
import 'package:weight_repository/weight_repository.dart';

part 'edit_weight_goal_form_event.dart';
part 'edit_weight_goal_form_state.dart';

class EditWeightGoalFormBloc extends Bloc<EditWeightGoalFormEvent, EditWeightGoalFormState> {
  EditWeightGoalFormBloc({
    required WeightGoal goal,
    required WeightRepository weightRepository,
  })   : _weightRepository = weightRepository,
        super(
          EditWeightGoalFormState.pure(goal),
        );

  final WeightRepository _weightRepository;

  @override
  Stream<EditWeightGoalFormState> mapEventToState(
    EditWeightGoalFormEvent event,
  ) async* {
    if (event is EditWeightGoalTargetDateChanged) {
      yield _mapTargetDateChangedToState(event);
    } else if (event is EditWeightGoalStartDateChanged) {
      yield _mapStartDateChanged(event);
    } else if (event is EditWeightGoalStartWeigthChanged) {
      yield _mapStartWeightToState(event);
    } else if (event is EditWeightGoalTargetWeightChanged) {
      yield _mapTargetWeightChangedToState(event);
    } else if (event is EditWeightGoalFormSubmit) {
      yield* _mapFormSubmitToState(event);
    }
  }

  EditWeightGoalFormState _mapTargetDateChangedToState(EditWeightGoalTargetDateChanged event) {
    final date = models.TargetDate.dirty(event.value);

    return state.copyWith(
      targetDate: date,
      status: Formz.validate([date, state.startDate, state.targetWeight, state.startWeight]),
    );
  }

  EditWeightGoalFormState _mapStartDateChanged(EditWeightGoalStartDateChanged event) {
    final date = models.StartDate.dirty(event.value);

    return state.copyWith(
      startDate: date,
      status: Formz.validate([date, state.startWeight, state.targetDate, state.targetWeight]),
    );
  }

  EditWeightGoalFormState _mapStartWeightToState(EditWeightGoalStartWeigthChanged event) {
    final weight = models.Weight.dirty(event.value);

    return state.copyWith(
      startWeight: weight,
      status: Formz.validate([weight, state.startDate, state.targetDate, state.targetWeight]),
    );
  }

  EditWeightGoalFormState _mapTargetWeightChangedToState(EditWeightGoalTargetWeightChanged event) {
    final weight = models.Weight.dirty(event.value);

    return state.copyWith(
      targetWeight: weight,
      status: Formz.validate([weight, state.startDate, state.targetDate, state.startWeight]),
    );
  }

  Stream<EditWeightGoalFormState> _mapFormSubmitToState(EditWeightGoalFormSubmit event) async* {
    final startWeight = models.Weight.dirty(state.startWeight.value);
    final startDate = models.StartDate.dirty(state.startDate.value);
    final targetDate = models.TargetDate.dirty(state.targetDate.value);
    final targetWeight = models.Weight.dirty(state.targetWeight.value);

    yield state.copyWith(
      startWeight: startWeight,
      startDate: startDate,
      targetDate: targetDate,
      targetWeight: targetWeight,
      status: Formz.validate([startWeight, startDate, targetDate, targetWeight]),
    );

    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      WeightGoal weightGoal = WeightGoal(
        beginDate: state.startDate.value,
        beginWeight: double.parse(state.startWeight.value),
        targetDate: state.targetDate.value,
        targetWeight: double.parse(state.targetWeight.value),
      );
    }
  }
}

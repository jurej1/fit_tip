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
  }) : super(EditWeightGoalFormState.pure(goal));

  @override
  Stream<EditWeightGoalFormState> mapEventToState(
    EditWeightGoalFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

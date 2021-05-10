import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'edit_weight_goal_form_event.dart';
part 'edit_weight_goal_form_state.dart';

class EditWeightGoalFormBloc extends Bloc<EditWeightGoalFormEvent, EditWeightGoalFormState> {
  EditWeightGoalFormBloc() : super(EditWeightGoalFormState());

  @override
  Stream<EditWeightGoalFormState> mapEventToState(
    EditWeightGoalFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

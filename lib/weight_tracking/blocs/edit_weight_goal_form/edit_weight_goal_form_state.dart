part of 'edit_weight_goal_form_bloc.dart';

class EditWeightGoalFormState extends Equatable {
  const EditWeightGoalFormState({
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;

  @override
  List<Object> get props => [status];
}

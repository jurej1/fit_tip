part of 'edit_weight_goal_form_bloc.dart';

abstract class EditWeightGoalFormEvent extends Equatable {
  const EditWeightGoalFormEvent();

  @override
  List<Object?> get props => [];
}

class EditWeightGoalTargetDateChanged extends EditWeightGoalFormEvent {
  final DateTime? value;

  const EditWeightGoalTargetDateChanged({this.value});
  @override
  List<Object?> get props => [value];
}

class EditWeightGoalStartDateChanged extends EditWeightGoalFormEvent {
  final DateTime? value;

  const EditWeightGoalStartDateChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class EditWeightGoalStartWeigthChanged extends EditWeightGoalFormEvent {
  final String? value;

  const EditWeightGoalStartWeigthChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class EditWeightGoalTargetWeightGoalChanged extends EditWeightGoalFormEvent {
  final String? value;

  const EditWeightGoalTargetWeightGoalChanged({this.value});

  @override
  List<Object?> get props => [value];
}

class EditWeightGoalFormSubmit extends EditWeightGoalFormEvent {}

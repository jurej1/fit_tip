part of 'edit_weight_goal_form_bloc.dart';

class EditWeightGoalFormState extends Equatable {
  const EditWeightGoalFormState({
    this.status = FormzStatus.pure,
    required this.targetDate,
    required this.startDate,
    required this.targetWeight,
    required this.startWeight,
    required this.weeklyGoal,
    this.weightGoal,
  });

  final FormzStatus status;
  final models.TargetDate targetDate;
  final models.StartDate startDate;
  final models.Weight startWeight;
  final models.Weight targetWeight;
  final WeeklyGoal weeklyGoal;
  final WeightGoal? weightGoal;

  factory EditWeightGoalFormState.pure(WeightGoal goal) {
    return EditWeightGoalFormState(
      targetDate: models.TargetDate.pure(goal.targetDate),
      startDate: models.StartDate.pure(goal.beginDate),
      targetWeight: models.Weight.pure(goal.targetWeight == null ? '' : goal.targetWeight.toString()),
      startWeight: models.Weight.pure(goal.beginWeight == null ? '' : goal.beginWeight.toString()),
      weeklyGoal: goal.weeklyGoal,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      targetDate,
      startDate,
      startWeight,
      targetWeight,
      weeklyGoal,
      weightGoal,
    ];
  }

  EditWeightGoalFormState copyWith({
    FormzStatus? status,
    models.TargetDate? targetDate,
    models.StartDate? startDate,
    models.Weight? startWeight,
    models.Weight? targetWeight,
    WeeklyGoal? weeklyGoal,
    WeightGoal? weightGoal,
  }) {
    return EditWeightGoalFormState(
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      startDate: startDate ?? this.startDate,
      startWeight: startWeight ?? this.startWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      weightGoal: weightGoal ?? this.weightGoal,
    );
  }
}

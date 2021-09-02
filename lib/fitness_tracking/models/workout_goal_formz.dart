import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutGoalValidationError { invalid }

class WorkoutGoalFormz extends FormzInput<WorkoutGoal?, WorkoutGoalValidationError> {
  const WorkoutGoalFormz.dirty([WorkoutGoal? value]) : super.dirty(value);
  const WorkoutGoalFormz.pure([WorkoutGoal? value]) : super.pure(value);

  @override
  WorkoutGoalValidationError? validator(WorkoutGoal? value) {
    if (value == null) return null;

    if (!WorkoutGoal.values.contains(value)) return WorkoutGoalValidationError.invalid;

    return null;
  }
}

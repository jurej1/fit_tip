import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutGoalValidationError { invalid }

class WorkoutGoalFormz extends FormzInput<WorkoutGoal, WorkoutGoalValidationError> {
  const WorkoutGoalFormz.dirty([WorkoutGoal value = WorkoutGoal.inscreaseStrength]) : super.dirty(value);
  const WorkoutGoalFormz.pure([WorkoutGoal value = WorkoutGoal.inscreaseStrength]) : super.pure(value);

  @override
  WorkoutGoalValidationError? validator(WorkoutGoal? value) {
    if (value == null) {
      return WorkoutGoalValidationError.invalid;
    }
    return null;
  }
}

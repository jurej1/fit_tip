import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutTypeValidationError { invalid }

class WorkoutTypeFormz extends FormzInput<WorkoutType, WorkoutTypeValidationError> {
  const WorkoutTypeFormz.dirty([WorkoutType value = WorkoutType.split]) : super.dirty(value);
  const WorkoutTypeFormz.pure([WorkoutType value = WorkoutType.split]) : super.pure(value);

  @override
  WorkoutTypeValidationError? validator(WorkoutType? value) {
    if (value == null) {
      return WorkoutTypeValidationError.invalid;
    }
    return null;
  }
}

import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutLevelValidationError { invalid }

class WorkoutLevelFormz extends FormzInput<Level, WorkoutLevelValidationError> {
  const WorkoutLevelFormz.dirty([Level value = Level.intermediate]) : super.dirty(value);
  const WorkoutLevelFormz.pure([Level value = Level.intermediate]) : super.pure(value);

  @override
  WorkoutLevelValidationError? validator(Level? value) {
    if (value == null) {
      return WorkoutLevelValidationError.invalid;
    }
    return null;
  }
}

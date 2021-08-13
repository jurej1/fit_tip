import 'package:formz/formz.dart';

enum WorkoutExcerciseNameValidationError { invalid }

class WorkoutExcerciseName extends FormzInput<String, WorkoutExcerciseNameValidationError> {
  const WorkoutExcerciseName.dirty([String value = '']) : super.dirty(value);
  const WorkoutExcerciseName.pure([String value = '']) : super.pure(value);

  @override
  WorkoutExcerciseNameValidationError? validator(String? value) {
    if (value == null) {
      return WorkoutExcerciseNameValidationError.invalid;
    }
    return null;
  }
}

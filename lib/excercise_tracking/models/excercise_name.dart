import 'package:formz/formz.dart';

enum ExcerciseNameValidationError { invalid }

class ExcerciseName extends FormzInput<String, ExcerciseNameValidationError> {
  const ExcerciseName.dirty([String value = '']) : super.dirty(value);
  const ExcerciseName.pure([String value = '']) : super.pure(value);

  @override
  ExcerciseNameValidationError? validator(String? value) {
    if (value == null) {
      return ExcerciseNameValidationError.invalid;
    }
    return null;
  }
}

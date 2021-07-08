import 'package:formz/formz.dart';

enum ExcerciseDurationValidationError { invalid }

class ExcerciseDuration extends FormzInput<int, ExcerciseDurationValidationError> {
  const ExcerciseDuration.dirty([int value = 0]) : super.dirty(value);
  const ExcerciseDuration.pure([int value = 0]) : super.pure(value);

  @override
  ExcerciseDurationValidationError? validator(int? value) {
    if (value == null) {
      return ExcerciseDurationValidationError.invalid;
    }

    return null;
  }
}

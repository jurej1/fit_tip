import 'package:formz/formz.dart';

enum ExcerciseStartDateValidationError { invalid }

class ExcerciseStartDate extends FormzInput<DateTime, ExcerciseStartDateValidationError> {
  ExcerciseStartDate.dirty([DateTime? value]) : super.dirty(value ?? DateTime.now());
  ExcerciseStartDate.pure([DateTime? value]) : super.pure(value ?? DateTime.now());

  @override
  ExcerciseStartDateValidationError? validator(DateTime? value) {
    if (value == null) {
      return ExcerciseStartDateValidationError.invalid;
    }

    return null;
  }
}

import 'package:formz/formz.dart';

enum BirthdateInputValidationError { invalid }

class BirthdateInput extends FormzInput<DateTime, BirthdateInputValidationError> {
  const BirthdateInput.dirty(DateTime value) : super.dirty(value);
  const BirthdateInput.pure(DateTime value) : super.pure(value);

  @override
  BirthdateInputValidationError? validator(DateTime? value) {
    if (value == null) {
      return BirthdateInputValidationError.invalid;
    }
    return null;
  }
}

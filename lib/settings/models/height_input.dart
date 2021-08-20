import 'package:formz/formz.dart';

enum HeightInputValidationError { invalid }

class HeightInput extends FormzInput<double, HeightInputValidationError> {
  const HeightInput.dirty([double value = 0]) : super.dirty(value);
  const HeightInput.pure([double value = 0]) : super.pure(value);

  @override
  HeightInputValidationError? validator(double? value) {
    if (value == null) {
      return HeightInputValidationError.invalid;
    }
    return null;
  }
}

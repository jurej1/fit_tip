import 'package:formz/formz.dart';

enum HeightInputValidationError { invalid }

class HeightInput extends FormzInput<String, HeightInputValidationError> {
  const HeightInput.dirty([String value = '']) : super.dirty(value);
  const HeightInput.pure([String value = '']) : super.pure(value);

  @override
  HeightInputValidationError? validator(String? value) {
    if (value == null) {
      return HeightInputValidationError.invalid;
    }
    return null;
  }
}

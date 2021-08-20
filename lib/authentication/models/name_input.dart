import 'package:formz/formz.dart';

enum NameInputValidationError { invalid }

class NameInput extends FormzInput<String, NameInputValidationError> {
  const NameInput.dirty([String value = '']) : super.dirty(value);
  const NameInput.pure([String value = '']) : super.pure(value);

  @override
  NameInputValidationError? validator(String? value) {
    if (value == null) {
      return NameInputValidationError.invalid;
    }
    if (value.length > 20) {
      return NameInputValidationError.invalid;
    }
    return null;
  }
}

import 'package:formz/formz.dart';

enum DisplayNameInputValidationError { invalid }

class DisplayNameInput extends FormzInput<String, DisplayNameInputValidationError> {
  const DisplayNameInput.dirty([String value = '']) : super.dirty(value);
  const DisplayNameInput.pure([String value = '']) : super.pure(value);

  @override
  DisplayNameInputValidationError? validator(String? value) {
    if (value == null) {
      return DisplayNameInputValidationError.invalid;
    }
    return null;
  }
}

import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.dirty([String val = '']) : super.dirty(val);
  const Password.pure([String val = '']) : super.pure(val);

  static final _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null) {
      return PasswordValidationError.invalid;
    } else if (_passwordRegex.hasMatch(value)) {
      return null;
    }

    return PasswordValidationError.invalid;
  }
}

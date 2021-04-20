import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String val = '']) : super.pure(val);
  const Email.dirty([String val = '']) : super.dirty(val);

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  @override
  EmailValidationError? validator(String value) {
    if (_emailRegex.hasMatch(value)) {
      return null;
    }

    return EmailValidationError.invalid;
  }
}

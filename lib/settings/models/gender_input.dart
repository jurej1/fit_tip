import 'package:authentication_repository/authentication_repository.dart';
import 'package:formz/formz.dart';

enum GenderInputValidationError { invalid }

class GenderInput extends FormzInput<Gender, GenderInputValidationError> {
  const GenderInput.dirty([Gender value = Gender.unknown]) : super.dirty(value);
  const GenderInput.pure([Gender value = Gender.unknown]) : super.pure(value);

  @override
  GenderInputValidationError? validator(value) {
    if (value == null) return GenderInputValidationError.invalid;
    return null;
  }
}

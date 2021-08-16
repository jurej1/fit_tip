import 'package:formz/formz.dart';

enum BirthdayInputValidtionError { invalid }

class BirthdayInput extends FormzInput<DateTime?, BirthdayInputValidtionError> {
  const BirthdayInput.dirty(DateTime? value) : super.dirty(value);
  const BirthdayInput.pure(DateTime? value) : super.pure(value);

  @override
  BirthdayInputValidtionError? validator(DateTime? value) {
    return null;
  }
}

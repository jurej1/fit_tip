import 'package:formz/formz.dart';

enum IntroductionInputValidationError { invalid }

class IntroductionInput extends FormzInput<String, IntroductionInputValidationError> {
  const IntroductionInput.dirty([String value = '']) : super.dirty(value);
  const IntroductionInput.pure([String value = '']) : super.pure(value);

  @override
  IntroductionInputValidationError? validator(String? value) {
    if (value == null) {
      return IntroductionInputValidationError.invalid;
    }
    return null;
  }
}

import 'package:formz/formz.dart';

enum IntroductionLineInputValidationError { invalid }

class IntroductionLineInput extends FormzInput<String, IntroductionLineInputValidationError> {
  const IntroductionLineInput.dirty([String value = '']) : super.dirty(value);
  const IntroductionLineInput.pure([String value = '']) : super.pure(value);

  @override
  IntroductionLineInputValidationError? validator(String? value) {
    if (value == null) {
      return IntroductionLineInputValidationError.invalid;
    }
    return null;
  }
}

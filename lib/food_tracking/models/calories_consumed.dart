import 'package:formz/formz.dart';

enum CaloriesConsumedValidatorError { invalid }

class CalorieConsumed extends FormzInput<String, CaloriesConsumedValidatorError> {
  const CalorieConsumed.dirty([String value = '']) : super.dirty(value);
  const CalorieConsumed.pure([String value = '']) : super.pure(value);

  @override
  CaloriesConsumedValidatorError? validator(String? value) {
    if (value == null) {
      return CaloriesConsumedValidatorError.invalid;
    }

    final double? val = double.tryParse(value);

    if (val == null) {
      return CaloriesConsumedValidatorError.invalid;
    }

    return null;
  }
}

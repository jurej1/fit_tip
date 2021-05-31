import 'package:formz/formz.dart';

enum WaterGoalAmountValidationError { invalid }

class WaterGoalAmount extends FormzInput<String, WaterGoalAmountValidationError> {
  const WaterGoalAmount.pure([String val = '']) : super.pure(val);
  const WaterGoalAmount.dirty([String val = '']) : super.dirty(val);

  @override
  WaterGoalAmountValidationError? validator(String? value) {
    if (value == null) {
      return WaterGoalAmountValidationError.invalid;
    } else if (double.tryParse(value) != null) {
      return null;
    }

    return null;
  }
}

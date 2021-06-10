import 'package:formz/formz.dart';

enum CalorieGoalConsumptionValidationError { invalid }

class CalorieGoalConsumption extends FormzInput<String, CalorieGoalConsumptionValidationError> {
  const CalorieGoalConsumption.dirty([String value = '']) : super.dirty(value);
  const CalorieGoalConsumption.pure([String value = '']) : super.pure(value);

  @override
  CalorieGoalConsumptionValidationError? validator(String? value) {
    if (value == null) {
      return CalorieGoalConsumptionValidationError.invalid;
    }

    return null;
  }
}

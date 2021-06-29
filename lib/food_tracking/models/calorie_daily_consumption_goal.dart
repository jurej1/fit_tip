import 'package:formz/formz.dart';

enum CalorieDailyConsumptionGoalValidationError { invalid, mealsContainsMoreCalories }

class CalorieDailyConsumptionGoal extends FormzInput<String, CalorieDailyConsumptionGoalValidationError> {
  CalorieDailyConsumptionGoal.dirty({
    String value = '',
    String snack = '',
    String dinner = '',
    String lunch = '',
    String breakfast = '',
  })  : this._breakfast = int.tryParse(breakfast) ?? 0,
        this._lunch = int.tryParse(lunch) ?? 0,
        this._dinner = int.tryParse(dinner) ?? 0,
        this._snack = int.tryParse(snack) ?? 0,
        super.dirty(value);

  CalorieDailyConsumptionGoal.pure({
    String value = '',
    String snack = '',
    String dinner = '',
    String lunch = '',
    String breakfast = '',
  })  : this._breakfast = int.tryParse(breakfast) ?? 0,
        this._lunch = int.tryParse(lunch) ?? 0,
        this._dinner = int.tryParse(dinner) ?? 0,
        this._snack = int.tryParse(snack) ?? 0,
        super.pure(value);

  final int _snack;
  final int _dinner;
  final int _lunch;
  final int _breakfast;

  @override
  CalorieDailyConsumptionGoalValidationError? validator(String? value) {
    if (value == null) {
      return CalorieDailyConsumptionGoalValidationError.invalid;
    }
    int? val = int.tryParse(value);

    if (val == null) {
      return CalorieDailyConsumptionGoalValidationError.invalid;
    }

    final int totalAmount = _snack + _lunch + _dinner + _breakfast;

    if (totalAmount > val) {
      return CalorieDailyConsumptionGoalValidationError.mealsContainsMoreCalories;
    }

    return null;
  }
}

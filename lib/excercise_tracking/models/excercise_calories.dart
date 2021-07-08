import 'package:formz/formz.dart';

enum ExcerciseCaloriesValidationError { invalid }

class ExcerciseCalories extends FormzInput<String, ExcerciseCaloriesValidationError> {
  const ExcerciseCalories.dirty([String value = '']) : super.dirty(value);
  const ExcerciseCalories.pure([String value = '']) : super.pure(value);

  @override
  ExcerciseCaloriesValidationError? validator(String? value) {
    if (value == null) {
      return ExcerciseCaloriesValidationError.invalid;
    }

    int? sourceValue = int.tryParse(value);

    if (sourceValue == null) {
      return ExcerciseCaloriesValidationError.invalid;
    }
    return null;
  }
}

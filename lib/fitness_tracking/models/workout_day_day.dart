import 'package:formz/formz.dart';

enum WorkoutDayDayValidationError { invalid }

class WorkoutDayDay extends FormzInput<String, WorkoutDayDayValidationError> {
  const WorkoutDayDay.dirty([String value = '']) : super.dirty(value);
  const WorkoutDayDay.pure([String value = '']) : super.pure(value);

  @override
  WorkoutDayDayValidationError? validator(String? value) {
    if (value == null) {
      return WorkoutDayDayValidationError.invalid;
    }

    final int? valueInt = int.tryParse(value);

    if (valueInt == null) {
      return WorkoutDayDayValidationError.invalid;
    }

    if (valueInt > 7) {
      return WorkoutDayDayValidationError.invalid;
    }

    return null;
  }
}

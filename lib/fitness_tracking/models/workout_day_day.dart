import 'package:formz/formz.dart';

enum WorkoutDayDayValidationError { invalid }

class WorkoutDayDay extends FormzInput<int, WorkoutDayDayValidationError> {
  const WorkoutDayDay.dirty([int value = 0]) : super.dirty(value);
  const WorkoutDayDay.pure([int value = 0]) : super.pure(value);

  @override
  WorkoutDayDayValidationError? validator(int? value) {
    if (value == null) {
      return WorkoutDayDayValidationError.invalid;
    }

    if (value > 7) {
      return WorkoutDayDayValidationError.invalid;
    }

    return null;
  }
}

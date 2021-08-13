import 'package:formz/formz.dart';

enum WorkoutTitleValidationError { invalid }

class WorkoutTitle extends FormzInput<String, WorkoutTitleValidationError> {
  const WorkoutTitle.dirty([String value = '']) : super.dirty(value);
  const WorkoutTitle.pure([String value = '']) : super.pure(value);

  @override
  WorkoutTitleValidationError? validator(String? value) {
    if (value == null) return null;

    if (value.length > 100) return WorkoutTitleValidationError.invalid;
    return null;
  }
}

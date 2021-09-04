import 'package:formz/formz.dart';

enum WorkoutPublicValidationError { invalid }

class WorkoutPublicFormz extends FormzInput<bool, WorkoutPublicValidationError> {
  const WorkoutPublicFormz.dirty([bool value = true]) : super.dirty(value);
  const WorkoutPublicFormz.pure([bool value = true]) : super.pure(value);

  @override
  WorkoutPublicValidationError? validator(bool? value) {
    if (value == null) return WorkoutPublicValidationError.invalid;

    return null;
  }
}

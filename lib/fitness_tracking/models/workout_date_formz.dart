import 'package:formz/formz.dart';

enum WorkoutDateValidationError { invalid }

class WorkoutDateFormz extends FormzInput<DateTime, WorkoutDateValidationError> {
  WorkoutDateFormz.dirty([DateTime? value]) : super.dirty(value ?? DateTime.now());
  WorkoutDateFormz.pure([DateTime? value]) : super.pure(value ?? DateTime.now());

  @override
  WorkoutDateValidationError? validator(DateTime? value) {
    if (value == null) {
      return WorkoutDateValidationError.invalid;
    }

    return null;
  }
}

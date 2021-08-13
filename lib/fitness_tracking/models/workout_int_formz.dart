import 'package:formz/formz.dart';

enum WorkoutIntValidationError { invalid }

class WorkoutIntFormz extends FormzInput<String, WorkoutIntValidationError> {
  const WorkoutIntFormz.dirty([String value = '']) : super.dirty(value);
  const WorkoutIntFormz.pure([String value = '']) : super.pure(value);

  int getIntValue() => int.tryParse(this.value) ?? 0;

  @override
  WorkoutIntValidationError? validator(String? value) {
    if (value == null) {
      return WorkoutIntValidationError.invalid;
    }

    int? val = int.tryParse(value);

    if (val == null) {
      return WorkoutIntValidationError.invalid;
    }
    return null;
  }
}

import 'package:formz/formz.dart';

enum WorkoutExcerciseIntFormzValidationError { invalid }

class WorkoutExcerciseIntFormz extends FormzInput<int, WorkoutExcerciseIntFormzValidationError> {
  const WorkoutExcerciseIntFormz.dirty([int value = 1]) : super.dirty(value);
  const WorkoutExcerciseIntFormz.pure([int value = 1]) : super.pure(value);

  @override
  WorkoutExcerciseIntFormzValidationError? validator(int? value) {
    if (value == null) {
      return WorkoutExcerciseIntFormzValidationError.invalid;
    }

    return null;
  }
}

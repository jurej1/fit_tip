import 'package:activity_repository/activity_repository.dart';
import 'package:formz/formz.dart';

enum ExcerciseTypeInputValidationError { invalid }

class ExcerciseTypeInput extends FormzInput<ExcerciseType, ExcerciseTypeInputValidationError> {
  const ExcerciseTypeInput.dirty([ExcerciseType value = ExcerciseType.endurance]) : super.dirty(value);
  const ExcerciseTypeInput.pure([ExcerciseType value = ExcerciseType.endurance]) : super.pure(value);

  @override
  ExcerciseTypeInputValidationError? validator(ExcerciseType? value) {
    if (value == null) {
      return ExcerciseTypeInputValidationError.invalid;
    }

    return null;
  }
}

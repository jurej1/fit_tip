import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutRepUnitValidationError { invalid }

class WorkoutRepUnit extends FormzInput<RepUnit, WorkoutRepUnitValidationError> {
  const WorkoutRepUnit.dirty([RepUnit value = RepUnit.x]) : super.dirty(value);
  const WorkoutRepUnit.pure([RepUnit value = RepUnit.x]) : super.pure(value);

  @override
  WorkoutRepUnitValidationError? validator(RepUnit? value) {
    if (value == null) return WorkoutRepUnitValidationError.invalid;
    return null;
  }
}

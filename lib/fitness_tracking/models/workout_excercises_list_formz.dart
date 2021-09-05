import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutExcercisesListValidationError { invalid }

class WorkoutExcercisesListFormz extends FormzInput<List<WorkoutExcercise>, WorkoutExcercisesListValidationError> {
  const WorkoutExcercisesListFormz.dirty([List<WorkoutExcercise> value = const []]) : super.dirty(value);
  const WorkoutExcercisesListFormz.pure([List<WorkoutExcercise> value = const []]) : super.pure(value);

  @override
  WorkoutExcercisesListValidationError? validator(List<WorkoutExcercise>? value) {
    if (value == null) {
      return WorkoutExcercisesListValidationError.invalid;
    }
    return null;
  }
}

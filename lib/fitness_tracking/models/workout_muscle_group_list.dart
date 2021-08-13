import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutMuscleGroupValidationError { invalid }

class WorkoutMuscleGroupList extends FormzInput<List<MuscleGroup>?, WorkoutMuscleGroupValidationError> {
  const WorkoutMuscleGroupList.dirty([List<MuscleGroup>? value]) : super.dirty(value);
  const WorkoutMuscleGroupList.pure([List<MuscleGroup>? value]) : super.pure(value);

  bool get containsMoreThanTwoMuscleGroups {
    if (this.value == null) {
      return false;
    }

    if (this.value!.isNotEmpty) {
      if (this.value!.length > 2) {
        return true;
      }
      return false;
    }

    return false;
  }

  @override
  WorkoutMuscleGroupValidationError? validator(List<MuscleGroup>? value) {
    return null;
  }
}

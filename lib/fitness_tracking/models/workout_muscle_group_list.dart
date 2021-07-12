import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutMuscleGroupValidationError { invalid }

class WorkoutMuscleGroupList extends FormzInput<List<MuscleGroup>?, WorkoutMuscleGroupValidationError> {
  const WorkoutMuscleGroupList.dirty([List<MuscleGroup>? value]) : super.dirty(value);
  const WorkoutMuscleGroupList.pure([List<MuscleGroup>? value]) : super.pure(value);

  List<MuscleGroup> get availableMuscleGroups {
    return MuscleGroup.values
      ..removeWhere(
        (element) {
          if (this.value == null) return false;
          if (this.value!.contains(element)) return true;
          return false;
        },
      );
  }

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
    bool isAnyNot = value?.any((element) => element is MuscleGroup) ?? false;

    if (isAnyNot) {
      return WorkoutMuscleGroupValidationError.invalid;
    }

    return null;
  }
}

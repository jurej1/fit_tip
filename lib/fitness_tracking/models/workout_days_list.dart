import 'package:fitness_repository/fitness_repository.dart';
import 'package:formz/formz.dart';

enum WorkoutDaysListValidationError { invalid }

class WorkoutDaysList extends FormzInput<List<WorkoutDay>, WorkoutDaysListValidationError> {
  const WorkoutDaysList.dirty({List<WorkoutDay> value = const [], this.workoutsPerWeekend = 0}) : super.dirty(value);
  const WorkoutDaysList.pure({List<WorkoutDay> value = const [], this.workoutsPerWeekend = 0}) : super.pure(value);

  final int workoutsPerWeekend;

  @override
  WorkoutDaysListValidationError? validator(List<WorkoutDay>? value) {
    if (value == null) {
      return WorkoutDaysListValidationError.invalid;
    }
    if (value.length != workoutsPerWeekend) {
      return WorkoutDaysListValidationError.invalid;
    }

    return null;
  }
}

import 'package:formz/formz.dart';

enum WorkoutDayNoteValidationError { invalid }

class WorkoutDayNote extends FormzInput<String?, WorkoutDayNoteValidationError> {
  final int maxLength = 100;

  const WorkoutDayNote.dirty([String? value]) : super.dirty(value);
  const WorkoutDayNote.pure([String? value]) : super.pure(value);

  @override
  WorkoutDayNoteValidationError? validator(String? value) {
    if (value == null) return null;

    if (value.length > maxLength) return WorkoutDayNoteValidationError.invalid;

    return null;
  }
}

import 'package:formz/formz.dart';

enum WorkoutNoteValidationError { invalid }

class WorkoutNote extends FormzInput<String, WorkoutNoteValidationError> {
  final int maxLength = 100;

  const WorkoutNote.dirty([String value = '']) : super.dirty(value);
  const WorkoutNote.pure([String value = '']) : super.pure(value);

  @override
  WorkoutNoteValidationError? validator(String? value) {
    if (value == null) {
      return WorkoutNoteValidationError.invalid;
    }
    if (value.length > maxLength) {
      return WorkoutNoteValidationError.invalid;
    }

    return null;
  }
}

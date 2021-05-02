import 'package:formz/formz.dart';

enum DateAddedValidationError { invalid }

class DateAdded extends FormzInput<DateTime, DateAddedValidationError> {
  DateAdded.pure([DateTime? date]) : super.pure(date ?? DateTime.now());
  DateAdded.dirty([DateTime? date]) : super.dirty(date ?? DateTime.now());

  @override
  DateAddedValidationError? validator(DateTime? value) {
    if (value == null) {
      return DateAddedValidationError.invalid;
    }
    bool isAfterToday = value.isAfter(DateTime.now());

    if (isAfterToday) {
      return DateAddedValidationError.invalid;
    }

    return null;
  }
}

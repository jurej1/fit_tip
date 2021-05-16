import 'package:formz/formz.dart';

enum StartDateValidationError { invalid }

class StartDate extends FormzInput<DateTime, StartDateValidationError> {
  StartDate.dirty([
    DateTime? value,
  ]) : super.dirty(value ?? DateTime.now());

  StartDate.pure([
    DateTime? value,
  ]) : super.pure(value ?? DateTime.now());

  @override
  StartDateValidationError? validator(DateTime? value) {
    final nowDate = DateTime.now();
    final day = nowDate.day;
    final month = nowDate.month;
    final year = nowDate.year;
    final now = DateTime(year, month, day);

    if (value == null) {
      return StartDateValidationError.invalid;
    }

    final valueDate = DateTime(
      value.year,
      value.month,
      value.year,
    );

    if (valueDate.isBefore(now)) {
      return StartDateValidationError.invalid;
    }

    return null;
  }
}

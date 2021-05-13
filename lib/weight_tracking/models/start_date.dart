import 'package:formz/formz.dart';

enum StartDateValidationError { invalid }

class StartDate extends FormzInput<DateTime, StartDateValidationError> {
  StartDate.dirty([DateTime? value, DateTime? targetDate])
      : _targetDate = targetDate,
        super.dirty(value ?? DateTime.now());

  StartDate.pure([DateTime? value, DateTime? targetDate])
      : _targetDate = targetDate,
        super.pure(value ?? DateTime.now());

  final DateTime? _targetDate;

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

    final nowVal = DateTime(
      value.year,
      value.month,
      value.year,
    );

    if (nowVal.isAfter(now)) {
      return StartDateValidationError.invalid;
    }

    if (_targetDate == null) {
      return null;
    }

    if (_targetDate!.isBefore(value)) {
      return StartDateValidationError.invalid;
    }

    return null;
  }
}

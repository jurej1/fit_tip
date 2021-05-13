import 'package:formz/formz.dart';

enum TargetDateValidationError { invalid }

class TargetDate extends FormzInput<DateTime, TargetDateValidationError> {
  TargetDate.dirty([
    DateTime? value,
    DateTime? startDate,
  ])  : _startDate = startDate,
        super.dirty(value ?? DateTime.now());
  TargetDate.pure([
    DateTime? value,
    DateTime? startDate,
  ])  : _startDate = startDate,
        super.pure(value ?? DateTime.now());

  final DateTime? _startDate;

  @override
  TargetDateValidationError? validator(DateTime? value) {
    if (value == null) {
      return TargetDateValidationError.invalid;
    }

    final today = DateTime.now();

    final nowDate = DateTime(
      today.year,
      today.month,
      today.year,
    );

    final valueDate = DateTime(
      value.year,
      value.month,
      value.day,
    );

    if (valueDate.isBefore(nowDate)) {
      return TargetDateValidationError.invalid;
    }

    if (_startDate == null) {
      return null;
    }

    if (_startDate!.isAfter(value)) {
      return TargetDateValidationError.invalid;
    }

    return null;
  }
}

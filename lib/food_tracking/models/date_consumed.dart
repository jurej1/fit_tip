import 'package:formz/formz.dart';

enum DateConsumedError { invalid }

class DateConsumed extends FormzInput<DateTime, DateConsumedError> {
  DateConsumed.pure([DateTime? date]) : super.pure(date ?? DateTime.now());
  DateConsumed.dirty([DateTime? date]) : super.dirty(date ?? DateTime.now());

  @override
  DateConsumedError? validator(DateTime? value) {
    if (value == null) {
      return DateConsumedError.invalid;
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (value.isAfter(today.add(const Duration(days: 1)))) {
        return DateConsumedError.invalid;
      }
      return null;
    }
  }
}

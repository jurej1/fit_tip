import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum TimeConsumedError { invalid }

class TimeConsumed extends FormzInput<TimeOfDay, TimeConsumedError> {
  TimeConsumed.pure([TimeOfDay? time]) : super.pure(time ?? TimeOfDay.now());
  TimeConsumed.dirty([TimeOfDay? time]) : super.dirty(time ?? TimeOfDay.now());

  @override
  TimeConsumedError? validator(value) {
    if (value == null) {
      return TimeConsumedError.invalid;
    }

    return null;
  }
}

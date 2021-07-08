import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum ExcerciseStartTimeValueValidationError { invalid }

class ExcerciseStartTime extends FormzInput<TimeOfDay, ExcerciseStartTimeValueValidationError> {
  ExcerciseStartTime.dirty([TimeOfDay? value]) : super.dirty(value ?? TimeOfDay.now());
  ExcerciseStartTime.pure([TimeOfDay? value]) : super.pure(value ?? TimeOfDay.now());

  @override
  ExcerciseStartTimeValueValidationError? validator(TimeOfDay? value) {
    if (value == null) {
      return ExcerciseStartTimeValueValidationError.invalid;
    }

    return null;
  }
}

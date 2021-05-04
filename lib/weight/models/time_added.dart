import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum TimeAddedValidationError { invalid }

class TimeAdded extends FormzInput<TimeOfDay, TimeAddedValidationError> {
  TimeAdded.dirty([
    TimeOfDay? value,
    DateTime? dateAdded,
  ])  : _dateAdded = dateAdded ?? DateTime.now(),
        super.dirty(value ?? TimeOfDay.now());

  TimeAdded.pure([
    TimeOfDay? value,
    DateTime? dateAdded,
  ])  : _dateAdded = dateAdded ?? DateTime.now(),
        super.pure(value ?? TimeOfDay.now());

  final DateTime _dateAdded;

  @override
  TimeAddedValidationError? validator(TimeOfDay? value) {
    if (value == null) {
      return TimeAddedValidationError.invalid;
    }

    final currentDate = DateTime.now();
    final selectedDate = DateTime(
      _dateAdded.year,
      _dateAdded.month,
      _dateAdded.day,
      value.hour,
      value.minute,
    );

    if (selectedDate.isAfter(currentDate)) {
      return TimeAddedValidationError.invalid;
    }

    return null;
  }
}

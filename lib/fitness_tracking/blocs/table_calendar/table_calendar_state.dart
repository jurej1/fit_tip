part of 'table_calendar_bloc.dart';

class TableCalendarState {
  const TableCalendarState({
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
  });

  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;

  factory TableCalendarState.pure(Workout workout) {
    return TableCalendarState(focusedDay: DateTime.now(), firstDay: workout.created, lastDay: workout.lastDay);
  }

  TableCalendarState copyWith({
    DateTime? focusedDay,
    DateTime? firstDay,
    DateTime? lastDay,
  }) {
    return TableCalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
    );
  }
}

part of 'calendar_bloc.dart';

enum CalendarMode {
  week,
  month,
  twoWeeks,
}

class CalendarState extends Equatable {
  const CalendarState({
    required this.focusedDate,
    required this.mode,
  });

  final DateTime focusedDate;
  final CalendarMode mode;

  factory CalendarState.pure() {
    return CalendarState(
      focusedDate: DateTime.now(),
      mode: CalendarMode.week,
    );
  }

  double get height {
    final double oneLineHeight = 50;

    if (mode == CalendarMode.week) return oneLineHeight;
    if (mode == CalendarMode.month) return oneLineHeight * 4;
    if (mode == CalendarMode.twoWeeks) return oneLineHeight * 2;
    return oneLineHeight;
  }

  @override
  List<Object> get props => [focusedDate, mode];

  CalendarState copyWith({
    DateTime? focusedDate,
    CalendarMode? mode,
  }) {
    return CalendarState(
      focusedDate: focusedDate ?? this.focusedDate,
      mode: mode ?? this.mode,
    );
  }
}

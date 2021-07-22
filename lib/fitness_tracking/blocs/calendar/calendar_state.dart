part of 'calendar_bloc.dart';

enum CalendarMode {
  week,
  twoWeeks,
  month,
}

class CalendarState extends Equatable {
  const CalendarState({
    required this.focusedDate,
    required this.mode,
    required this.firstDay,
    required this.lastDay,
  });

  final DateTime focusedDate;
  final CalendarMode mode;
  final int focusedPage = 1;
  final DateTime firstDay;
  final DateTime lastDay;

  factory CalendarState.pure({required DateTime firstDay, required int duration}) {
    return CalendarState(
      focusedDate: DateTime.now(),
      mode: CalendarMode.week,
      firstDay: firstDay,
      lastDay: firstDay.add(
        Duration(days: duration * 7),
      ),
    );
  }

  @override
  List<Object> get props => [focusedDate, mode, firstDay, lastDay];

  CalendarState copyWith({
    DateTime? focusedDate,
    CalendarMode? mode,
    DateTime? firstDay,
    DateTime? lastDay,
  }) {
    return CalendarState(
      focusedDate: focusedDate ?? this.focusedDate,
      mode: mode ?? this.mode,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
    );
  }

  double get height {
    final double oneLineHeight = 50;

    if (mode == CalendarMode.week) return oneLineHeight;
    if (mode == CalendarMode.month) return oneLineHeight * 4;
    if (mode == CalendarMode.twoWeeks) return oneLineHeight * 2;
    return oneLineHeight;
  }

  int get _durationDaysDifference => this.lastDay.difference(firstDay).inDays;

  int get itemCountWeeks {
    double value = _durationDaysDifference / 7;
    return value.round();
  }

  int get _itemCountMonths {
    double value = _durationDaysDifference / 30;
    return value.round();
  }
}

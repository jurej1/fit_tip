part of 'calendar_bloc.dart';

enum CalendarMode { week, month }

class CalendarState extends Equatable {
  const CalendarState({
    required this.mode,
    required this.firstDay,
    required this.lastDay,
    required this.size,
    required this.focusedDay,
  });

  final CalendarMode mode;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final Size size;

  factory CalendarState.pure({
    required DateTime firstDay,
    required DateTime lastDay,
    required Size size,
  }) {
    return CalendarState(
      mode: CalendarMode.week,
      firstDay: firstDay,
      focusedDay: DateTime.now(),
      lastDay: lastDay,
      size: size,
    );
  }

  @override
  List<Object> get props {
    return [
      mode,
      firstDay,
      lastDay,
      focusedDay,
      size,
    ];
  }

  CalendarState copyWith({
    CalendarMode? mode,
    DateTime? firstDay,
    DateTime? lastDay,
    DateTime? focusedDay,
    Size? size,
  }) {
    return CalendarState(
      mode: mode ?? this.mode,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
      focusedDay: focusedDay ?? this.focusedDay,
      size: size ?? this.size,
    );
  }

  double get height {
    final double oneLineHeight = 50;

    if (mode == CalendarMode.week) return oneLineHeight;
    if (mode == CalendarMode.month) return oneLineHeight * 4;
    return oneLineHeight;
  }

  int get calenderWeekModeItemCount {
    return lastCalendarDayWeekMode.difference(firstCalendarDayWeekMode).inDays ~/ 7;
  }

  int get calendarMonthModeItemCount {
    return lastCalenderDayMonthMode.difference(firstCalenderDayMonthMode).inDays ~/ 30;
  }

  int get focusedDayPageIndexWeekMode {
    return firstCalendarDayWeekMode.difference(focusedDay).inDays ~/ 7;
  }

  double get itemWidth => size.width / 7;

  DateTime get firstCalendarDayWeekMode {
    DateTime firstDayPure = DateTime(firstDay.year, firstDay.month, firstDay.day);

    if (firstDayPure.weekday == DateTime.monday) return firstDayPure;
    return DateTime(firstDayPure.year, firstDayPure.month, ((firstDay.day - firstDay.weekday) + 1));
  }

  DateTime get lastCalendarDayWeekMode {
    DateTime lastDayPure = DateTime(lastDay.year, lastDay.month, lastDay.day);

    if (lastDayPure.weekday == DateTime.sunday) return lastDayPure;
    return DateTime(lastDayPure.year, lastDayPure.month, ((lastDayPure.day - lastDayPure.weekday) + 8));
  }

  DateTime get firstCalenderDayMonthMode {
    DateTime firstDayPure = DateTime(firstDay.year, firstDay.month, firstDay.day);

    if (firstDayPure.day == 1 && firstDayPure.weekday == DateTime.monday) return firstDayPure;

    DateTime firstDayOfTheMonth = DateTime(firstDayPure.year, firstDay.month, 1);

    return firstDayOfTheMonth.subtract(Duration(days: firstDayOfTheMonth.weekday - 1));
  }

  DateTime get lastCalenderDayMonthMode {
    DateTime lastDayPure = DateTime(lastDay.year, lastDay.month, lastDay.day);
    final lastDayOfTheMonth = DateTime(lastDay.year, lastDay.month + 1, 0);

    if (lastDayOfTheMonth.weekday == DateTime.sunday) return lastDayOfTheMonth;
    if (lastDayPure == lastDayOfTheMonth && lastDayPure.weekday == DateTime.sunday) return lastDayPure;

    return lastDayOfTheMonth.add(Duration(days: (7 - lastDay.weekday)));
  }
}

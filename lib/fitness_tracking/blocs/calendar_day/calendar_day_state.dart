part of 'calendar_day_bloc.dart';

class CalendarDayState extends Equatable {
  const CalendarDayState({
    required this.day,
    required this.index,
    required this.isSelected,
    required this.itemWidth,
    required this.isUnimported,
  });

  final DateTime day;
  final int index;
  final bool isSelected;
  final bool isUnimported;
  final double itemWidth;

  factory CalendarDayState.pure(CalendarBloc calendarBloc, CalendarFocusedDayBloc focusedDayBloc, {required int index}) {
    final DateTime focusedDay = focusedDayBloc.state;
    final DateTime focusedDayPure = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);

    final DateTime firstDay = calendarBloc.state.firstDay;
    final DateTime lastDay = calendarBloc.state.lastDay;
    final DateTime startDatePure = DateTime(firstDay.year, firstDay.month, firstDay.day);
    final DateTime lastDayPure = DateTime(lastDay.year, lastDay.month, lastDay.day);

    if (calendarBloc.state.mode == CalendarMode.week) {
      final DateTime day = calendarBloc.state.firstCalendarDayWeekMode.add(Duration(days: index));
      final DateTime dayPure = DateTime(day.year, day.month, day.day);
      return CalendarDayState(
        day: dayPure,
        index: index,
        isSelected: focusedDayPure == dayPure,
        isUnimported: dayPure.isBefore(startDatePure) || dayPure.isAfter(lastDayPure),
        itemWidth: calendarBloc.state.itemWidth,
      );
    } else {
      final DateTime day = calendarBloc.state.firstCalenderDayMonthMode.add(Duration(days: index));
      final DateTime dayPure = DateTime(day.year, day.month, day.day);
      return CalendarDayState(
        day: dayPure,
        index: index,
        isSelected: focusedDayPure == dayPure,
        isUnimported: dayPure.isBefore(startDatePure) || dayPure.isAfter(lastDayPure),
        itemWidth: calendarBloc.state.itemWidth,
      );
    }
  }

  @override
  List<Object> get props {
    return [
      day,
      index,
      isSelected,
      isUnimported,
      itemWidth,
    ];
  }

  CalendarDayState copyWith({
    DateTime? day,
    int? index,
    bool? isSelected,
    bool? isUnimported,
    double? itemWidth,
  }) {
    return CalendarDayState(
      day: day ?? this.day,
      index: index ?? this.index,
      isSelected: isSelected ?? this.isSelected,
      isUnimported: isUnimported ?? this.isUnimported,
      itemWidth: itemWidth ?? this.itemWidth,
    );
  }

  DateTime get _thisPureDay => DateTime(this.day.year, this.day.month, this.day.day);

  bool isDaySelected(DateTime selectedDay) {
    DateTime selectedPure = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    return _thisPureDay == selectedPure;
  }
}

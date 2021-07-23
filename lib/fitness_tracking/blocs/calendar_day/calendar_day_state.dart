part of 'calendar_day_bloc.dart';

class CalendarDayState extends Equatable {
  const CalendarDayState({
    required this.day,
    required this.index,
    required this.isSelected,
    required this.isUnimported,
  });

  final DateTime day;
  final int index;
  final bool isSelected;
  final bool isUnimported;

  factory CalendarDayState.calculateFromIndex(CalendarBloc calendarBloc, CalendarFocusedDayBloc focusedDayBloc, {required int index}) {
    final DateTime day = calendarBloc.state.firstMonday.add(Duration(days: index));
    final DateTime firstDay = calendarBloc.state.firstDay;
    final DateTime lastDay = calendarBloc.state.lastDay;

    final DateTime dayPure = DateTime(day.year, day.month, day.day);
    final DateTime focusedDay = focusedDayBloc.state;
    final DateTime focusedDayPure = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);

    DateTime startDatePure = DateTime(firstDay.year, firstDay.month, firstDay.day);
    DateTime lastDayPure = DateTime(lastDay.year, lastDay.month, lastDay.day);

    return CalendarDayState(
      day: dayPure,
      index: index,
      isSelected: focusedDayPure == dayPure,
      isUnimported: dayPure.isBefore(startDatePure) || dayPure.isAfter(lastDayPure),
    );
  }

  @override
  List<Object> get props => [day, index, isSelected, isUnimported];

  CalendarDayState copyWith({
    DateTime? day,
    int? index,
    bool? isSelected,
    bool? isDayBeforeStartDay,
  }) {
    return CalendarDayState(
      day: day ?? this.day,
      index: index ?? this.index,
      isSelected: isSelected ?? this.isSelected,
      isUnimported: isDayBeforeStartDay ?? this.isUnimported,
    );
  }

  DateTime get _thisPureDay => DateTime(this.day.year, this.day.month, this.day.day);

  bool isDaySelected(DateTime selectedDay) {
    DateTime selectedPure = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    return _thisPureDay == selectedPure;
  }
}

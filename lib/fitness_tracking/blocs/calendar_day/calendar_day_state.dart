part of 'calendar_day_bloc.dart';

class CalendarDayState extends Equatable {
  const CalendarDayState({
    required this.day,
    required this.index,
    required this.isSelected,
  });

  final DateTime day;
  final int index;
  final bool isSelected;

  factory CalendarDayState.calculateFromIndex(CalendarBloc calendarBloc, CalendarFocusedDayBloc focusedDayBloc, {required int index}) {
    final DateTime day = calendarBloc.state.firstMonday.add(Duration(days: index));

    final DateTime dayPure = DateTime(day.year, day.month, day.day);
    final DateTime focusedDay = focusedDayBloc.state;
    final DateTime focusedDayPure = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);

    return CalendarDayState(
      day: day,
      index: index,
      isSelected: focusedDayPure == dayPure,
    );
  }

  @override
  List<Object> get props => [day, index, isSelected];

  CalendarDayState copyWith({
    DateTime? day,
    int? index,
    bool? isSelected,
  }) {
    return CalendarDayState(
      day: day ?? this.day,
      index: index ?? this.index,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool isDaySelected(DateTime selectedDay) {
    DateTime thisPureDay = DateTime(this.day.year, this.day.month, this.day.day);
    DateTime selectedPure = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    return thisPureDay == selectedPure;
  }
}

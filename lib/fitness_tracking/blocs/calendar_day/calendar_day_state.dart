part of 'calendar_day_bloc.dart';

class CalendarDayState extends Equatable {
  const CalendarDayState({
    required this.day,
  });

  final DateTime day;

  factory CalendarDayState.calculateFromIndex(DateTime startDate, {required int index}) {
    return CalendarDayState(
      day: startDate.add(Duration(days: index)),
    );
  }

  @override
  List<Object> get props => [day];

  CalendarDayState copyWith({
    DateTime? day,
  }) {
    return CalendarDayState(
      day: day ?? this.day,
    );
  }
}

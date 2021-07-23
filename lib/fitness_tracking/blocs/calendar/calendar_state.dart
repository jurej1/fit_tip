part of 'calendar_bloc.dart';

enum CalendarMode { week, twoWeeks, month }
enum CalendarListStatus { initial, scrollEnd, scrolling }

class CalendarState extends Equatable {
  const CalendarState({
    required this.mode,
    required this.firstDay,
    required this.lastDay,
    required this.size,
    this.pageIndex = 0,
    this.listStatus = CalendarListStatus.initial,
    this.offset = 0,
  });

  final CalendarMode mode;
  final DateTime firstDay;
  final DateTime lastDay;
  final Size size;
  final int pageIndex;
  final double offset;
  final CalendarListStatus listStatus;

  factory CalendarState.pure({
    required DateTime firstDay,
    required DateTime lastDay,
    required Size size,
  }) {
    return CalendarState(
      mode: CalendarMode.week,
      firstDay: firstDay,
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
      size,
      pageIndex,
      offset,
      listStatus,
    ];
  }

  CalendarState copyWith({
    CalendarMode? mode,
    DateTime? firstDay,
    DateTime? lastDay,
    Size? size,
    int? pageIndex,
    double? offset,
    CalendarListStatus? listStatus,
  }) {
    return CalendarState(
      mode: mode ?? this.mode,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
      size: size ?? this.size,
      pageIndex: pageIndex ?? this.pageIndex,
      offset: offset ?? this.offset,
      listStatus: listStatus ?? this.listStatus,
    );
  }

  double get height {
    final double oneLineHeight = 50;

    if (mode == CalendarMode.week) return oneLineHeight;
    if (mode == CalendarMode.month) return oneLineHeight * 4;
    if (mode == CalendarMode.twoWeeks) return oneLineHeight * 2;
    return oneLineHeight;
  }

  int get durationDaysDifference {
    return lastDay.difference(firstMonday).inDays;
  }

  int get durationMonthDifference {
    final months = lastDay.difference(firstDay).inDays / 30;
    return months.round();
  }

  int get itemCountWeeks {
    double value = durationDaysDifference / 7;
    return value.round();
  }

  double get itemWidth => size.width / 7;

  double getAnimateToValue() {
    int animateToIndex = pageIndex * 7;

    return animateToIndex * itemWidth;
  }

  int get pageFirstIndex => pageIndex * 7;
  int get pageLastIndex => pageFirstIndex + 7;

  DateTime get pageFirstIndexDate => firstDay.add(Duration(days: pageFirstIndex));
  DateTime get pageLastIndexDate => pageFirstIndexDate.add(Duration(days: 7));

  DateTime get firstMonday {
    DateTime firstDayPure = DateTime(firstDay.year, firstDay.month, firstDay.day);

    if (firstDayPure.weekday == DateTime.monday) return firstDayPure;
    return DateTime(firstDayPure.year, firstDayPure.month, ((firstDay.day - firstDay.weekday) + 1));
  }
}

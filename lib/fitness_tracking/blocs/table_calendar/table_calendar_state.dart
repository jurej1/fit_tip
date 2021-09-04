part of 'table_calendar_bloc.dart';

abstract class TableCalendarState extends Equatable {
  const TableCalendarState();

  @override
  List<Object?> get props => [];

  factory TableCalendarState.initial(ActiveWorkoutBloc activeWorkoutBloc) {
    ActiveWorkoutState activeState = activeWorkoutBloc.state;
    final isSuccess = activeState is ActiveWorkoutLoadSuccess;

    if (isSuccess) {
      activeState = activeState as ActiveWorkoutLoadSuccess;
      return TableCalendarLoadSuccess(
        focusedDay: DateTime.now(),
        firstDay: activeState.workout.info.startDate,
        workouts: activeState.workout.workoutDays!.workoutDays,
        lastDay: activeState.workout.lastDate,
      );
    }
    return TableCalendarLoading();
  }
}

class TableCalendarLoading extends TableCalendarState {}

class TableCalendarLoadSuccess extends TableCalendarState {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarFormat format;
  final List<WorkoutDay> workouts;

  const TableCalendarLoadSuccess({
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    this.format = CalendarFormat.twoWeeks,
    required this.workouts,
  });

  @override
  List<Object?> get props => [focusedDay, firstDay, lastDay, format, workouts];

  TableCalendarLoadSuccess copyWith({
    DateTime? focusedDay,
    DateTime? firstDay,
    DateTime? lastDay,
    CalendarFormat? format,
    List<WorkoutDay>? workouts,
  }) {
    return TableCalendarLoadSuccess(
      focusedDay: focusedDay ?? this.focusedDay,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
      format: format ?? this.format,
      workouts: workouts ?? this.workouts,
    );
  }

  List<int> getEvents(DateTime day) {
    final int length = this.workouts.fold<int>(0, (previousValue, element) {
      if (element.weekday == day.weekday) {
        return previousValue + 1;
      }
      return previousValue;
    });

    return List<int>.generate(length, (index) => index);
  }
}

class TableCalendarFail extends TableCalendarState {}

import 'dart:developer';

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../fitness_tracking.dart';

class TableCalendarBuilder extends StatelessWidget {
  const TableCalendarBuilder({Key? key}) : super(key: key);

  static Widget route(BuildContext context, {Key? key, required Workout workout}) {
    return BlocProvider(
      create: (context) => TableCalendarBloc(workout: workout),
      child: TableCalendarBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableCalendarBloc, TableCalendarState>(
      builder: (context, state) {
        return TableCalendar(
          calendarFormat: CalendarFormat.twoWeeks,
          onFormatChanged: (newFormat) {},
          currentDay: state.focusedDay,
          focusedDay: state.focusedDay,
          firstDay: state.firstDay,
          lastDay: state.lastDay,
          onDaySelected: (selectedDay, focusedDay) {
            BlocProvider.of<TableCalendarBloc>(context).add(TableCalendarFocusedDayUpdated(focusedDay));
          },
        );
      },
    );
  }
}

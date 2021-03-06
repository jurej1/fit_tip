import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../fitness_tracking.dart';

class TableCalendarBuilder extends StatelessWidget {
  const TableCalendarBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableCalendarBloc, TableCalendarState>(
      builder: (context, state) {
        if (state is TableCalendarLoadSuccess) {
          return TableCalendar(
            eventLoader: state.getEvents,
            calendarFormat: state.format,
            onFormatChanged: (newFormat) {
              BlocProvider.of<TableCalendarBloc>(context).add(TableCalendarFormatUpdated(newFormat));
            },
            currentDay: state.focusedDay,
            focusedDay: state.focusedDay,
            firstDay: state.firstDay,
            lastDay: state.lastDay,
            onDaySelected: (selectedDay, focusedDay) {
              BlocProvider.of<TableCalendarBloc>(context).add(TableCalendarFocusedDayUpdated(focusedDay));
            },
          );
        }
        return Container();
      },
    );
  }
}

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../fitness_tracking.dart';

class TableCalendarBuilder extends StatelessWidget {
  const TableCalendarBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, activeState) {
        if (activeState is ActiveWorkoutLoadSuccess) {
          return BlocConsumer<TableCalendarBloc, TableCalendarState>(
            listener: (context, state) {
              BlocProvider.of<FocusedWorkoutDayBloc>(context).add(FocusedWorkoutDayDateUpdated(state.focusedDay));
            },
            builder: (context, calendarState) {
              return TableCalendar(
                eventLoader: activeState.getEvents,
                calendarFormat: calendarState.format,
                onFormatChanged: (newFormat) {
                  BlocProvider.of<TableCalendarBloc>(context).add(TableCalendarFormatUpdated(newFormat));
                },
                currentDay: calendarState.focusedDay,
                focusedDay: calendarState.focusedDay,
                firstDay: calendarState.firstDay,
                lastDay: calendarState.lastDay,
                onDaySelected: (selectedDay, focusedDay) {
                  BlocProvider.of<TableCalendarBloc>(context).add(TableCalendarFocusedDayUpdated(focusedDay));
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

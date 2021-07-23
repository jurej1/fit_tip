import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../fitness_tracking.dart';

class CalendarDayItem extends StatelessWidget {
  CalendarDayItem._({Key? key}) : super(key: key);

  static Widget weekCalendarItem(
    int index, {
    Key? key,
  }) {
    return BlocProvider(
      key: key,
      create: (context) => CalendarDayBloc(
        calendarBloc: BlocProvider.of<CalendarBloc>(context),
        focusedDayBloc: BlocProvider.of<CalendarFocusedDayBloc>(context),
        index: index,
      ),
      child: CalendarDayItem._(),
    );
  }

  final Color _selectedColor = Colors.blue;
  final Color _unimportantColor = Colors.grey.shade400;
  final Color _unselectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarFocusedDayBloc, DateTime>(
      listener: (context, state) {
        BlocProvider.of<CalendarDayBloc>(context).add(CalendarDaySelectedDayUpdated(state));
      },
      child: BlocBuilder<CalendarDayBloc, CalendarDayState>(
        builder: (context, state) {
          return Material(
            child: InkWell(
              onTap: state.isUnimported
                  ? null
                  : () {
                      BlocProvider.of<CalendarFocusedDayBloc>(context).add(
                        CalendarFocusedDayUpdated(
                          BlocProvider.of<CalendarDayBloc>(context).state.day,
                        ),
                      );
                    },
              child: Container(
                width: state.itemWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '${state.day.day}',
                      style: TextStyle(
                        color: state.isUnimported ? _unimportantColor : (state.isSelected ? _selectedColor : _unselectedColor),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Text(
                        DateFormat('E').format(state.day),
                        style: TextStyle(
                          color: state.isUnimported ? _unimportantColor : (state.isSelected ? _selectedColor : _unselectedColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../fitness_tracking.dart';

class CalendarDayItem extends StatelessWidget {
  CalendarDayItem._({Key? key}) : super(key: key);

  static Widget widget(
    int index, {
    Key? key,
  }) {
    return BlocProvider(
      key: key,
      create: (context) => CalendarDayBloc(
        calendarBloc: BlocProvider.of<CalendarBloc>(context),
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
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        BlocProvider.of<CalendarDayBloc>(context).add(CalendarDaySelectedDayUpdated(state.focusedDay));
      },
      child: BlocBuilder<CalendarDayBloc, CalendarDayState>(
        builder: (context, state) {
          return Material(
            child: InkWell(
              onTap: state.isUnimported
                  ? null
                  : () {
                      BlocProvider.of<CalendarBloc>(context).add(
                        CalendarFocusedDateUpdated(
                          BlocProvider.of<CalendarDayBloc>(context).state.day,
                        ),
                      );
                    },
              child: Container(
                width: state.itemWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: state.itemWidth * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.isSelected ? _selectedColor : Colors.transparent,
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      child: Text('${state.day.day}'),
                      style: TextStyle(
                        color: state.isUnimported ? _unimportantColor : (state.isSelected ? Colors.white : _unselectedColor),
                        fontSize: state.isSelected ? 16 : 14,
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

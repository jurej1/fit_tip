import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../fitness_tracking.dart';

class CalendarBuilder extends HookWidget {
  const CalendarBuilder({Key? key}) : super(key: key);

  static Widget route(
    BuildContext context, {
    required Workout workout,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CalendarBloc(
            workout: workout,
            size: MediaQuery.of(context).size,
          ),
        ),
        BlocProvider(
          create: (context) => CalendarFocusedDayBloc(),
        )
      ],
      child: CalendarBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener<CalendarFocusedDayBloc, DateTime>(
      listener: (context, state) {
        //TODO when date changes the list on the page should also update
      },
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CalendarBloc>(context).add(CalendarModeButtonPressed());
                },
                child: Text('ChangeMode'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('MMMM yy').format(state.pageFirstIndexDate),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              AnimatedContainer(
                height: state.height,
                duration: const Duration(milliseconds: 300),
                width: size.width,
                child: _buildCalenderBasedOnMode(state.mode),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalenderBasedOnMode(CalendarMode mode) {
    if (mode == CalendarMode.week) {
      return CalendarWeekView();
    } else if (mode == CalendarMode.twoWeeks) {
      return Container(
        color: Colors.red,
      );
    } else {
      return CalendarMonthView();
    }
  }
}

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return PageView.builder(
          itemCount: state.calendarMonthModeItemCount,
          itemBuilder: (context, pageIndex) {
            return GridView.builder(
              itemCount: 7 * 5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1 / 0.68,
              ),
              itemBuilder: (context, index) {
                final calculatedIndex = index + (pageIndex == 0 ? 0 : pageIndex * (7 * 5));
                return CalendarDayItem.weekCalendarItem(calculatedIndex);
              },
            );
          },
        );
      },
    );
  }
}

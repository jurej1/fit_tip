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
      ],
      child: CalendarBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM yy').format(state.focusedDay),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CalendarBloc>(context).add(CalendarModeButtonPressed());
                    },
                    child: Text('Change Mode'),
                  ),
                ],
              ),
            ),
            Row(
              children: List.generate(
                7,
                (index) {
                  return Container(
                    width: state.itemWidth,
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('E').format(
                        state.firstCalendarDayWeekMode.add(
                          Duration(days: index),
                        ),
                      ),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ),
            ),
            AnimatedContainer(
              height: state.height,
              duration: const Duration(milliseconds: 300),
              width: size.width,
              child: state.mode == CalendarMode.week ? CalendarWeekView() : CalendarMonthView(),
            ),
          ],
        );
      },
    );
  }
}

import 'package:fit_tip/authentication/authentication.dart';
import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:table_calendar/table_calendar.dart';

import '../fitness_tracking.dart';

class CalendarBuilder extends HookWidget {
  const CalendarBuilder({Key? key}) : super(key: key);

  static Widget route(
    BuildContext context, {
    required Workout workout,
  }) {
    return BlocProvider(
      create: (context) => CalendarBloc(workout: workout),
      child: CalendarBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CalendarBloc>(context).add(CalendarModeButtonPressed());
                },
                child: Text('Change mode')),
            AnimatedContainer(
              height: state.height,
              duration: const Duration(milliseconds: 300),
              color: Colors.red,
              width: size.width,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.itemCountWeeks,
                itemBuilder: (context, index) {
                  final width = size.width / 7;
                  return Container(
                    width: width,
                    color: Colors.blue,
                    padding: EdgeInsets.all(2),
                    child: Center(
                      child: Text('$index'),
                    ),
                  );
                },
                onPageChanged: (value) {
                  BlocProvider.of<CalendarBloc>(context).add(CalendarPageChanged(value));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

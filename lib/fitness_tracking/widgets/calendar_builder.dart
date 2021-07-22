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
      create: (_) => CalendarBloc(
        workout: workout,
        size: MediaQuery.of(context).size,
      ),
      child: CalendarBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _controller = useScrollController();

    final Size size = MediaQuery.of(context).size;
    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (contex, state) {
        if (state.listStatus == CalendarListStatus.scrollEnd) {
          _controller.animateTo(
            state.getAnimateToValue(),
            duration: const Duration(seconds: 2),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        }
      },
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
              width: size.width,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    BlocProvider.of<CalendarBloc>(context).add(CalendarScrollEndNotification(notification));
                  }
                  if (notification is ScrollUpdateNotification) {
                    BlocProvider.of<CalendarBloc>(context).add(CalendarScrollUpdateNotification(notification));
                  }

                  return false;
                },
                child: ListView.builder(
                  controller: _controller,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.durationDaysDifference,
                  itemBuilder: (context, index) {
                    return CalendarDayItem.route(
                      index,
                      key: ValueKey(index),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CalendarDayItem extends StatelessWidget {
  const CalendarDayItem({Key? key}) : super(key: key);

  static Widget route(
    int index, {
    Key? key,
  }) {
    return BlocProvider(
      key: key,
      create: (context) => CalendarDayBloc(
        calendarBloc: BlocProvider.of<CalendarBloc>(context),
        index: index,
      ),
      child: CalendarDayItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Material(
          child: InkWell(
            onTap: () {},
            child: Container(
              width: state.itemWidth,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.black38),
                  top: BorderSide(color: Colors.black38),
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              alignment: Alignment.center,
              child: BlocBuilder<CalendarDayBloc, CalendarDayState>(
                builder: (context, state) {
                  return Text('${state.day.day}');
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

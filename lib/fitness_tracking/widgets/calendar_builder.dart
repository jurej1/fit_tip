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
      return _CalendarWeekView();
    } else if (mode == CalendarMode.twoWeeks) {
      return Container(
        color: Colors.red,
      );
    } else {
      return Container();
    }
  }
}

class _CalendarWeekView extends HookWidget {
  const _CalendarWeekView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useScrollController();

    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (contex, state) {
        if (state.listStatus == CalendarListStatus.scrollEnd) {
          _controller.animateTo(
            state.getAnimateToValue(),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
          );
        }
      },
      builder: (context, state) {
        return NotificationListener<ScrollNotification>(
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
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: state.calendarItemsCount,
            itemBuilder: (context, index) {
              return CalendarDayItem.weekCalendarItem(
                index,
                key: ValueKey(index),
              );
            },
          ),
        );
      },
    );
  }
}

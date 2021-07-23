import 'dart:developer';

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
          child: Container(),
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MMMM').format(state.pageFirstIndexDate)),
                    if (state.pageLastIndexDate.month != state.pageFirstIndexDate.month)
                      Text(DateFormat('MMMM').format(state.pageLastIndexDate)),
                  ],
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
      return _CalendarMonthView();
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
            itemCount: state.durationDaysDifference,
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

class _CalendarMonthView extends StatelessWidget {
  const _CalendarMonthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return PageView.builder(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: state.durationMonthDifference,
          itemBuilder: (context, pageIndex) {
            return GridView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: 7 * 5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1 / 0.68,
              ),
              itemBuilder: (context, index) {
                return Text(DateFormat('d').format(DateTime(state.firstDay.year, state.firstDay.month + pageIndex, 0 + index)));
              },
            );
          },
        );
      },
    );
  }
}

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
    final _controller = useScrollController();

    final Size size = MediaQuery.of(context).size;
    return BlocListener<CalendarFocusedDayBloc, DateTime>(
      listener: (context, state) {
        //TODO when date changeds
      },
      child: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (contex, state) {
          if (state.listStatus == CalendarListStatus.scrollEnd) {
            _controller.animateTo(
              state.getAnimateToValue(),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
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
                child: Text('Change mode'),
              ),
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
                    physics: const BouncingScrollPhysics(),
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
      ),
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
        focusedDayBloc: BlocProvider.of<CalendarFocusedDayBloc>(context),
        index: index,
      ),
      child: CalendarDayItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarFocusedDayBloc, DateTime>(
      listener: (context, state) {
        BlocProvider.of<CalendarDayBloc>(context).add(CalendarDaySelectedDayUpdated(state));
      },
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          return Material(
            child: InkWell(
              onTap: () {
                BlocProvider.of<CalendarFocusedDayBloc>(context).add(
                  CalendarFocusedDayUpdated(
                    BlocProvider.of<CalendarDayBloc>(context).state.day,
                  ),
                );
              },
              child: Container(
                width: state.itemWidth,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.black38),
                    top: BorderSide(color: Colors.black38),
                    bottom: BorderSide(color: Colors.black38),
                  ),
                ),
                child: BlocBuilder<CalendarDayBloc, CalendarDayState>(
                  builder: (context, state) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${state.day.day}',
                          style: TextStyle(
                            color: state.isSelected ? Colors.blue : Colors.grey.shade400,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Text(
                            DateFormat('E').format(state.day),
                            style: TextStyle(
                              color: state.isSelected ? Colors.blue : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

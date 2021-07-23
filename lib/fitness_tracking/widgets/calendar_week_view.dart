import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class CalendarWeekView extends HookWidget {
  const CalendarWeekView({Key? key}) : super(key: key);

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
            itemCount: state.calenderWeekModeItemCount,
            itemBuilder: (context, index) {
              return CalendarDayItem.constructor(
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

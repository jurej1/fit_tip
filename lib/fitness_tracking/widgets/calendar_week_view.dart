import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class CalendarWeekView extends HookWidget {
  const CalendarWeekView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = usePageController();
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        _controller.jumpToPage(state.focusedDayPageIndexWeekMode);

        return PageView.builder(
          controller: _controller,
          itemCount: state.calenderWeekModeItemCount,
          itemBuilder: (context, pageIndex) {
            return ListView.builder(
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              itemExtent: state.itemWidth,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (contex, index) {
                final int calculatedIndex = index + (pageIndex == 0 ? 0 : pageIndex * 7);
                return CalendarDayItem.widget(calculatedIndex, key: ValueKey(calculatedIndex)); //TODOs
              },
            );
          },
        );
      },
    );
  }
}

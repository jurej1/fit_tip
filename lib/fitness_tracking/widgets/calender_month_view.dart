import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
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
                return CalendarDayItem.weekCalendarItem(calculatedIndex, key: ValueKey(calculatedIndex));
              },
            );
          },
        );
      },
    );
  }
}

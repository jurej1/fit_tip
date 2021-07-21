import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class CalendarBuilder extends StatelessWidget {
  const CalendarBuilder({Key? key}) : super(key: key);

  static Widget route(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(),
      child: CalendarBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return AnimatedContainer(
          height: state.height,
          duration: const Duration(milliseconds: 300),
          color: Colors.red,
          width: size.width,
        );
      },
    );
  }
}

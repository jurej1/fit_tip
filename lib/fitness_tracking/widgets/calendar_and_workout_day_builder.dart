import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class CalanderAndWokroutDayBuilder extends StatelessWidget {
  const CalanderAndWokroutDayBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoadSuccess) {
          return Container(
            child: ListView(
              children: [
                TableCalendarBuilder(),
                const SizedBox(height: 10),
                FocusedWorkoutDayBuilder(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

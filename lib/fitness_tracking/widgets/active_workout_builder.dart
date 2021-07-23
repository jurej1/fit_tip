import 'package:fit_tip/fitness_tracking/widgets/calendar_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class ActiveWorkoutBuilder extends StatelessWidget {
  const ActiveWorkoutBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoading) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is ActiveWorkoutLoadSuccess) {
          return PageView(
            physics: const ClampingScrollPhysics(),
            children: [
              Page1(),
              Page2(),
            ],
          );
        } else if (state is ActiveWorkoutNone) {
          return Center(
            child: Text('You don not have any active workout'),
          );
        }

        return Container();
      },
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoadSuccess) {
          return Container(
            child: ListView(
              children: [
                CalendarBuilder.route(context, workout: state.workout),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, state) {
        if (state is ActiveWorkoutLoadSuccess) {
          return Center(
            child: Text('${state.workout.id}s'),
          );
        }
        return Container();
      },
    );
  }
}

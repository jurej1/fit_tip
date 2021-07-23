import 'package:fitness_repository/fitness_repository.dart';
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
              const Page1(),
              const Page2(),
            ],
            onPageChanged: (index) {
              BlocProvider.of<ActiveWorkoutViewSelectorCubit>(context).viewUpdatedIndex(index);
            },
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
                TableCalendarBuilder.route(context, workout: state.workout),
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
          return ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              WorkoutInfoRow(
                created: state.workout.mapCreatedToText,
                daysPerWeek: state.workout.daysPerWeek.toStringAsFixed(0),
                goal: mapWorkoutGoalToText(state.workout.goal),
              ),
              if (state.workout.note != null) ...{
                Text(
                  'Info',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(state.workout.note!),
                const SizedBox(height: 10),
              },
              ...state.workout.workouts
                  .map(
                    (e) => WorkoutDetailItem(workout: e),
                  )
                  .toList(),
            ],
          );
        }
        return Container();
      },
    );
  }
}

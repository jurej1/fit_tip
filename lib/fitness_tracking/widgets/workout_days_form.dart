import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class WorkoutDaysForm extends StatelessWidget {
  const WorkoutDaysForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddWorkoutFormBloc, AddWorkoutFormState>(
      builder: (context, state) {
        return ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            final item = state.workoutDaysItems[index];
            return BlocProvider(
              key: ValueKey(item),
              create: (context) => WorkoutDayCardBloc(
                workoutDay: item,
              ),
              child: WorkoutDayCard(),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15,
            );
          },
          itemCount: state.workoutDaysLenght,
        );
      },
    );
  }
}

class WorkoutDayCard extends StatelessWidget {
  WorkoutDayCard({Key? key}) : super(key: key);

  final BorderRadius _borderRadius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDayCardBloc, WorkoutDayCardState>(
      builder: (context, state) {
        return Material(
          borderRadius: _borderRadius,
          color: Colors.blue.shade100,
          child: InkWell(
            borderRadius: _borderRadius,
            onTap: () {
              Navigator.of(context).push(AddWorkoutDayView.route(context, workoutDay: state.workoutDay));
            },
            child: ListTile(
              dense: true,
              title: Text(
                state.workoutDay.getDayText(),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:developer';

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_tip/fitness_tracking/blocs/blocs.dart';
import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';

class ExcercisePageCard extends StatelessWidget {
  const ExcercisePageCard({Key? key}) : super(key: key);

  static Widget provider(WorkoutExcercise excercise) {
    return BlocProvider(
      key: ValueKey(excercise),
      create: (context) => ExcercisePageCardBloc(excercise: excercise),
      child: ExcercisePageCard(
        key: ValueKey(excercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExcercisePageCardBloc, ExcercisePageCardState>(
      listener: (context, state) {
        log('Excercise page ' + state.getNewWorkoutExcercise().toString());
        BlocProvider.of<RunningWorkoutDayBloc>(context).add(RunningWorkoutDayWorkoutExcerciseUpdated(state.getNewWorkoutExcercise()));
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Goal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _GoalRowDisplayer(
                      title: 'Set goal',
                      value: '${state.excercise.setsString}x',
                    ),
                    _GoalRowDisplayer(
                      title: 'Rep goal',
                      value: '${state.excercise.repsString}x',
                    ),
                  ],
                ),
              ),
              ...List.generate(
                state.excercise.sets,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      '  Set ${index + 1}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SetDisplayer.provider(index, state.excercise),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GoalRowDisplayer extends StatelessWidget {
  const _GoalRowDisplayer({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class WorkoutDayCard extends StatelessWidget {
  WorkoutDayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDayCardBloc, WorkoutDayCardState>(
      builder: (context, state) {
        return Material(
          borderRadius: state.borderRadius,
          color: Colors.blue.shade100,
          child: InkWell(
            borderRadius: state.borderRadius,
            onTap: () {
              Navigator.of(context).push(AddWorkoutDayView.route(context, workoutDay: state.workoutDay));
            },
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text('Day: ${state.workoutDay.day}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<AddWorkoutFormBloc>(context).add(AddWorkoutFormListItemRemoved(state.workoutDay));
                        },
                        icon: Icon(Icons.delete),
                        iconSize: state.iconSize,
                      ),
                      _ExpansionButton(),
                    ],
                  ),
                ),
                _DataList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpansionButton extends HookWidget {
  const _ExpansionButton({Key? key}) : super(key: key);

  final double closedAngle = 1 / 2 * pi;
  final double expandedAngle = 3 / 2 * pi;
  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: closedAngle,
      upperBound: expandedAngle,
    );

    return BlocConsumer<WorkoutDayCardBloc, WorkoutDayCardState>(
      listener: (contex, state) {
        if (state.isExpanded) {
          _controller.forward();
        } else if (!state.isExpanded) {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value,
              child: child,
            );
          },
          child: IconButton(
            color: Colors.blue,
            icon: const Icon(Icons.arrow_back_ios_new),
            iconSize: state.iconSize,
            onPressed: () {
              BlocProvider.of<WorkoutDayCardBloc>(context).add(WorkoutDayCardExpandedButtonPressed());
            },
          ),
        );
      },
    );
  }
}

class _DataList extends StatelessWidget {
  const _DataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDayCardBloc, WorkoutDayCardState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: state.borderRadius,
          child: AnimatedContainer(
            height: state.isExpanded ? 80 : 0,
            duration: const Duration(milliseconds: 300),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                Text(
                  'Number of excercises: ${state.workoutDay.numberOfExcercises}',
                  style: TextStyle(height: 1),
                ),
                const SizedBox(height: 3),
                Text(
                  'Day of the week: ${state.workoutDay.mapDayToText}',
                  style: TextStyle(height: 1),
                ),
                const SizedBox(height: 3),
                Wrap(
                  children: state.workoutDay.musclesTargeted?.map(
                        (e) {
                          return Chip(
                            label: Text(describeEnum(e)),
                          );
                        },
                      ).toList() ??
                      [],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

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
              trailing: _ExpansionButton(),
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
            icon: const Icon(Icons.arrow_back_ios_new),
            iconSize: 20,
            onPressed: () {
              BlocProvider.of<WorkoutDayCardBloc>(context).add(WorkoutDayCardExpandedButtonPressed());
            },
          ),
        );
      },
    );
  }
}

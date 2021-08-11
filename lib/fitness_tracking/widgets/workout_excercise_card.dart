import 'dart:math';

import 'package:fitness_repository/fitness_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../fitness_tracking.dart';

class WorkoutExcerciseCard extends StatelessWidget {
  const WorkoutExcerciseCard({Key? key}) : super(key: key);

  static Widget provider(WorkoutExcercise excercise) {
    return BlocProvider(
      create: (context) => WorkoutExcerciseCardBloc(excercise: excercise),
      child: WorkoutExcerciseCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutExcerciseCardBloc, WorkoutExcerciseCardState>(
      builder: (context, state) {
        return Material(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(state.excercise.name),
                _RotatableArrowIcon(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RotatableArrowIcon extends HookWidget {
  const _RotatableArrowIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: -pi / 2,
      upperBound: -(3 * pi) / 2,
    );
    return BlocConsumer<WorkoutExcerciseCardBloc, WorkoutExcerciseCardState>(
      listener: (context, state) {
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
            iconSize: 20,
            onPressed: () {
              BlocProvider.of<WorkoutExcerciseCardBloc>(context).add(WorkoutExcerciseCardArrowPressed());
            },
            icon: const Icon(Icons.arrow_forward_ios_outlined),
          ),
        );
      },
    );
  }
}

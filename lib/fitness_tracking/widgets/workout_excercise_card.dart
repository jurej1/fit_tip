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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.excercise.name),
                      const _RotatableArrowIcon(),
                    ],
                  ),
                ),
                AnimatedContainer(
                  height: state.isExpanded ? 100 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sets'),
                          Text('${state.excercise.sets}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reps'),
                          Text('${state.excercise.reps}'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 10),
                      ..._dataListBuilder(state),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _dataListBuilder(WorkoutExcerciseCardState state) {
    return List.generate(
      state.excercise.sets,
      (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Set ${index + 1}',
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Text(
                'Reps: ${state.excercise.repCount?[index]}',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'Weight: ${state.excercise.weightCount?[index].toStringAsFixed(0)}kg',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );
      },
    ).toList();
  }
}

class _RotatableArrowIcon extends HookWidget {
  const _RotatableArrowIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: -pi / 2,
      initialValue: -pi / 2,
      upperBound: pi / 2,
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

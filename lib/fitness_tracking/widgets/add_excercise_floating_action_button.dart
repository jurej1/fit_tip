import 'dart:math';

import 'package:fit_tip/fitness_tracking/blocs/add_workout_view/add_workout_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExcerciseFloatingActionButton extends StatefulWidget {
  const AddExcerciseFloatingActionButton({Key? key}) : super(key: key);

  @override
  _AddExcerciseFloatingActionButtonState createState() => _AddExcerciseFloatingActionButtonState();
}

class _AddExcerciseFloatingActionButtonState extends State<AddExcerciseFloatingActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 80,
      upperBound: 0,
      duration: const Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddWorkoutViewCubit, AddWorkoutFormView>(
      listener: (context, view) {
        if (view == AddWorkoutFormView.workout) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _controller.value),
              child: child,
            );
          },
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
        );
      },
    );
  }
}

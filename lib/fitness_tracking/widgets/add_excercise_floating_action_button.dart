import 'package:fit_tip/fitness_tracking/blocs/add_workout_view/add_workout_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_tracking.dart';

class AddExcerciseFloatingActionButton extends StatefulWidget {
  const AddExcerciseFloatingActionButton({Key? key}) : super(key: key);

  @override
  _AddExcerciseFloatingActionButtonState createState() => _AddExcerciseFloatingActionButtonState();
}

class _AddExcerciseFloatingActionButtonState extends State<AddExcerciseFloatingActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offfsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );

    _offfsetAnimation = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
        reverseCurve: Curves.easeIn,
      ),
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
    return BlocListener<AddWorkoutViewCubit, AddWorkoutFormViewState>(
      listener: (context, state) {
        if (state.view == AddWorkoutFormView.days) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _offfsetAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _offfsetAnimation.value),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1),
              opacity: _controller.value,
              child: child,
            ),
          );
        },
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(AddWorkoutDayView.route(context));
          },
        ),
      ),
    );
  }
}

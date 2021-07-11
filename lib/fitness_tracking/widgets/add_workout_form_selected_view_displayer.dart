import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddWorkoutFormSelectedViewDisplayer extends StatefulWidget {
  const AddWorkoutFormSelectedViewDisplayer({Key? key}) : super(key: key);

  @override
  _AddWorkoutFormSelectedViewDisplayerState createState() => _AddWorkoutFormSelectedViewDisplayerState();
}

class _AddWorkoutFormSelectedViewDisplayerState extends State<AddWorkoutFormSelectedViewDisplayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      upperBound: AddWorkoutFormView.values.length.toDouble(),
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
        _controller.animateTo(AddWorkoutFormView.values.indexOf(state.view).toDouble());
      },
      child: Container(
        height: 30,
        child: SelectedViewDisplayer(
          controller: _controller,
          dotSize: 10,
          length: AddWorkoutFormView.values.length,
          selectedColor: Colors.blue,
          unselectedColor: Colors.grey.shade300,
          width: 40,
        ),
      ),
    );
  }
}

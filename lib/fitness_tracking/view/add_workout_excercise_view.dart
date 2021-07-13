import 'package:flutter/material.dart';

class AddWorkoutExcerciseView extends StatelessWidget {
  const AddWorkoutExcerciseView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return AddWorkoutExcerciseView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout Excercise View'),
      ),
    );
  }
}

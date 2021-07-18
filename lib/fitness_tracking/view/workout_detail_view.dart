import 'package:flutter/material.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(builder: (_) {
      return WorkoutDetailView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout detail page'),
      ),
    );
  }
}

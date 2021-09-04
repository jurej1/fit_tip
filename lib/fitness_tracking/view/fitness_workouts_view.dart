import 'package:flutter/material.dart';

class FitnessWorkoutsView extends StatelessWidget {
  const FitnessWorkoutsView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (_) {
        return FitnessWorkoutsView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Workouts View'),
      ),
    );
  }
}

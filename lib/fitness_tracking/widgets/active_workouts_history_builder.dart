import 'package:fit_tip/app.dart';
import 'package:flutter/material.dart';

import '../fitness_tracking.dart';

class ActiveWorkoutsHistoryBuilder extends StatelessWidget {
  const ActiveWorkoutsHistoryBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active workouts history'),
      ),
      bottomNavigationBar: FitnessTrackingViewSelector(),
    );
  }
}

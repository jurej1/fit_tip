import 'package:fit_tip/excercise_tracking/excercise_tracking.dart';
import 'package:fit_tip/fitness_tracking/view/fitness_tracking_view.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/water_tracking/view/view.dart';
import 'package:fit_tip/weight_tracking/weight.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(Icons.ac_unit),
              title: Text('Weight tracking'),
              onTap: () {
                Navigator.of(context).push(WeightTrackingView.route(context));
              },
            ),
            ListTile(
              leading: const Icon(Icons.water_damage_outlined),
              title: Text('Water tracking'),
              onTap: () {
                Navigator.of(context).push(WaterLogView.route(context));
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank),
              title: Text('Food tracking'),
              onTap: () {
                Navigator.of(context).push(FoodDailyLogsView.route(context));
              },
            ),
            ListTile(
              leading: Icon(Icons.sports),
              title: Text('Excercise tracking'),
              onTap: () {
                Navigator.of(context).push(ExcerciseDailyTrackingView.route(context));
              },
            ),
            ListTile(
              leading: Icon(Icons.sports),
              title: Text('Fitness tracking'),
              onTap: () {
                Navigator.of(context).push(FitnessTrackingView.route(context));
              },
            )
          ],
        ),
      ),
    );
  }
}

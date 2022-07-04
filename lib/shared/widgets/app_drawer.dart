import 'package:fit_tip/fitness_tracking/fitness_tracking.dart';
import 'package:fit_tip/settings/settings.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // ListTile(
            //   leading: const Icon(Icons.ac_unit),
            //   title: Text('Weight tracking'),
            //   onTap: () {
            //     Navigator.of(context).push(WeightTrackingView.route(context));
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.water_damage_outlined),
            //   title: Text('Water tracking'),
            //   onTap: () {
            //     Navigator.of(context).push(WaterLogView.route(context));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.food_bank),
            //   title: Text('Food tracking'),
            //   onTap: () {
            //     Navigator.of(context).push(FoodDailyLogsView.route(context));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.sports),
            //   title: Text('Excercise tracking'),
            //   onTap: () {
            //     Navigator.of(context).push(ExcerciseDailyTrackingView.route(context));
            //   },
            // ),
            // ListTile(
            //   title: const Text('Blog'),
            //   leading: const Icon(Icons.document_scanner_outlined),
            //   onTap: () {
            //     Navigator.of(context).push(BlogPostsView.route(context));
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.sports),
              title: Text('Fitness tracking'),
              onTap: () {
                Navigator.of(context).push(FitnessTrackingView.route(context));
              },
            ),
            ListTile(
              leading: const Icon(Icons.ballot_outlined),
              title: Text('Workouts'),
              onTap: () {
                Navigator.of(context).push(FitnessWorkoutsView.route(context));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(SettingsView.route(context));
              },
            )
          ],
        ),
      ),
    );
  }
}

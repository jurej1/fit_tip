import 'package:flutter/material.dart';

class FoodDailyLogsView extends StatelessWidget {
  const FoodDailyLogsView({Key? key}) : super(key: key);

  static const routeName = 'food_daily_logs_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily logs'),
      ),
    );
  }
}

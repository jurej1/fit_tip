import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDailyLogsView extends StatelessWidget {
  const FoodDailyLogsView({Key? key}) : super(key: key);

  static const routeName = 'food_daily_logs_view';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily logs'),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            FoodLogDaySelector(),
            FoodLogBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddFoodLogView.routeName,
            arguments: {
              0: BlocProvider.of<FoodDailyLogsBloc>(context),
            },
          );
        },
      ),
    );
  }
}

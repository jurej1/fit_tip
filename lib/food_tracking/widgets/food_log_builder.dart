import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/widgets/food_daily_progres.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodLogBuilder extends StatelessWidget {
  const FoodLogBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<FoodDailyLogsBloc, FoodDailyLogsState>(
      builder: (context, state) {
        if (state is FoodDailyLogsLoading) {
          return SizedBox(
            height: 5,
            width: size.width,
            child: LinearProgressIndicator(),
          );
        } else if (state is FoodDailyLogsLoadSuccess) {
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FoodDailyProgress(),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}

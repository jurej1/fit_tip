import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/widgets/food_daily_progres.dart';
import 'package:fit_tip/food_tracking/widgets/meal_expansion_tile.dart';
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
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  BlocProvider(
                    create: (context) => FoodDayProgressBloc(
                      calorieDailyGoalBloc: BlocProvider.of<CalorieDailyGoalBloc>(context),
                      foodDailyLogsBloc: BlocProvider.of<FoodDailyLogsBloc>(context),
                    ),
                    child: FoodDailyProgress(),
                  ),
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      MealExpansionTile(
                        meal: state.mealDay?.breakfast,
                        title: 'Breakfest',
                      ),
                      const SizedBox(height: 10),
                      MealExpansionTile(
                        meal: state.mealDay?.lunch,
                        title: 'Lunch',
                      ),
                      const SizedBox(height: 10),
                      MealExpansionTile(
                        meal: state.mealDay?.dinner,
                        title: 'Dinner',
                      ),
                      const SizedBox(height: 10),
                      MealExpansionTile(
                        meal: state.mealDay?.snacks,
                        title: 'Snacks',
                      ),
                    ],
                  ),
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

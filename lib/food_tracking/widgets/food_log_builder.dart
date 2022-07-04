import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class FoodLogBuilder extends StatelessWidget {
  const FoodLogBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDailyLogsBloc, FoodDailyLogsState>(
      builder: (context, state) {
        if (state is FoodDailyLogsLoading) {
          return const LinearProgressIndicator();
        } else if (state is FoodDailyLogsLoadSuccess) {
          return Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const _CalorieChart(),
                  MealCustomTile(
                    key: UniqueKey(),
                    mealType: MealType.breakfast,
                    meal: state.mealDay.breakfast,
                    title: 'Breakfast',
                  ),
                  const SizedBox(height: 10),
                  MealCustomTile(
                    mealType: MealType.lunch,
                    key: UniqueKey(),
                    meal: state.mealDay.lunch,
                    title: 'Lunch',
                  ),
                  const SizedBox(height: 10),
                  MealCustomTile(
                    mealType: MealType.dinner,
                    key: UniqueKey(),
                    meal: state.mealDay.dinner,
                    title: 'Dinner',
                  ),
                  const SizedBox(height: 10),
                  MealCustomTile(
                    mealType: MealType.snack,
                    key: UniqueKey(),
                    meal: state.mealDay.snacks,
                    title: 'Snacks',
                  ),
                  const SizedBox(height: 75),
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

class _CalorieChart extends StatelessWidget {
  const _CalorieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodDayProgressBloc(
        calorieDailyGoalBloc: BlocProvider.of<CalorieDailyGoalBloc>(context),
        foodDailyLogsBloc: BlocProvider.of<FoodDailyLogsBloc>(context),
      ),
      child: const FoodDailyProgress(),
    );
  }
}

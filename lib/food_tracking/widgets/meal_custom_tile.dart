import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

import 'package:fit_tip/food_tracking/blocs/blocs.dart';

import 'food_item_tile.dart';

class MealCustomTile extends StatelessWidget {
  MealCustomTile({
    Key? key,
    this.meal,
    required this.title,
    required this.mealType,
  }) : super(key: key);

  final Meal? meal;
  final String title;
  final MealType mealType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealCustomTileBloc(
        mealType: mealType,
        meal: meal,
        calorieDailyGoalBloc: BlocProvider.of<CalorieDailyGoalBloc>(context),
      ),
      child: _MainTile(
        title: title,
      ),
    );
  }
}

class _MainTile extends StatelessWidget {
  _MainTile({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealCustomTileBloc, MealCustomTileState>(
      builder: (context, state) {
        return Column(
          children: [
            TilePressedLineIndicator(
              isExpanded: state.isExpanded,
              duration: duration,
              color: state.textActiveColor,
            ),
            _ColapsedTile(
              amountOfItems: state.foods.length,
              title: title,
              meal: state.meal,
            ),
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: duration,
              height: state.isExpanded ? calculateHeight(state) : 0,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: state.foods.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.foods[index];

                  return BlocProvider(
                    create: (context) => FoodItemTileBloc(
                      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                      foodItem: item,
                      foodRepository: RepositoryProvider.of<FoodRepository>(context),
                    ),
                    child: FoodItemTile(
                      key: ValueKey(item),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  double calculateHeight(MealCustomTileState state) {
    return state.hasFoods() ? (state.foods.length < 5 ? (state.foods.length * 65) : (4 * 65)) : 0;
  }
}

class _ColapsedTile extends StatelessWidget {
  const _ColapsedTile({
    Key? key,
    this.meal,
    required this.title,
    required this.amountOfItems,
  }) : super(key: key);

  final Meal? meal;
  final String title;
  final int amountOfItems;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealCustomTileBloc, MealCustomTileState>(
      builder: (context, state) {
        return ListTile(
          dense: true,
          title: Text(
            title,
            style: TextStyle(
              color: state.isExpanded ? state.textActiveColor : Colors.black,
            ),
          ),
          subtitle: Text(
            amountOfItems == 1 ? '1 item' : '$amountOfItems items',
            style: TextStyle(
              color: state.isExpanded ? state.textActiveColor.withOpacity(0.4) : Colors.grey.shade400,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (meal?.totalCalories.toStringAsFixed(0) ?? '0') + ' cal',
                style: TextStyle(
                  color: state.isExpanded ? state.textActiveColor : Colors.black,
                ),
              ),
              if (state.mealCalorieGoal != null)
                Text(
                  ' / ' + state.mealCalorieGoal.toString() + ' cal',
                  style: TextStyle(
                    color: state.isExpanded ? state.textActiveColor.withOpacity(0.4) : Colors.grey.shade400,
                  ),
                )
            ],
          ),
          onTap: () {
            BlocProvider.of<MealCustomTileBloc>(context).add(MealCustomTileExpandedPressed());
          },
        );
      },
    );
  }
}

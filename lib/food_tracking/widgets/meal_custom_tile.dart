import 'package:fit_tip/authentication/authentication.dart';
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
  })   : this.amountOfItems = meal?.foods.length ?? 0,
        super(key: key);

  final Meal? meal;
  final String title;
  final int amountOfItems;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealCustomTileBloc(),
      child: _MainTile(
        amountOfItems: amountOfItems,
        title: title,
        meal: meal,
      ),
    );
  }
}

class _MainTile extends StatelessWidget {
  _MainTile({
    Key? key,
    this.meal,
    required this.title,
    required this.amountOfItems,
  })   : this.hasFoods = meal?.foods.isNotEmpty ?? false,
        this.foods = meal?.foods ?? [],
        super(key: key);

  final Meal? meal;
  final String title;
  final int amountOfItems;
  final bool hasFoods;
  final List<FoodItem> foods;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealCustomTileBloc, MealCustomTileState>(
      builder: (context, state) {
        return Column(
          children: [
            AnimatedContainer(
              duration: duration,
              height: state.isExpanded ? 1.75 : 0,
              width: state.isExpanded ? MediaQuery.of(context).size.width * 0.8 : 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: state.isExpanded ? state.textActiveColor : Colors.white,
              ),
            ),
            _ColapsedTile(
              amountOfItems: amountOfItems,
              title: title,
              meal: meal,
            ),
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: duration,
              height: state.isExpanded ? calculateHeight() : 0,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: foods.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = foods[index];

                  return BlocProvider(
                    create: (context) => FoodItemTileBloc(
                      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                      foodItem: item,
                      foodRepository: RepositoryProvider.of<FoodRepository>(context),
                    ),
                    child: FoodItemTile(
                      key: ValueKey(item.id),
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

  double calculateHeight() {
    return hasFoods ? (foods.length < 5 ? (foods.length * 65) : (4 * 65)) : 0;
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
          trailing: Text(
            (meal?.totalCalories.toStringAsFixed(0) ?? '0') + ' cal',
            style: TextStyle(
              color: state.isExpanded ? state.textActiveColor : Colors.black,
            ),
          ),
          onTap: () {
            BlocProvider.of<MealCustomTileBloc>(context).add(MealCustomTileExpandedPressed());
          },
        );
      },
    );
  }
}

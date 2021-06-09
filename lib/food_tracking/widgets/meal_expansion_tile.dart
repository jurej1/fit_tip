import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:food_repository/food_repository.dart';

class MealExpansionTile extends StatelessWidget {
  const MealExpansionTile({
    Key? key,
    this.meal,
    required this.title,
  }) : super(key: key);

  final Meal? meal;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      trailing: Text('${meal != null ? meal!.totalCalories.toStringAsFixed(0) : '0'} cal'),
      children: [
        if (meal != null)
          SizedBox(
            height: meal?.foods.length != null ? (meal!.foods.length < 5 ? (meal!.foods.length * 60) : (4 * 60)) : 0,
            child: FoodLogsList(
              foods: meal!.foods,
            ),
          ),
      ],
    );
  }
}

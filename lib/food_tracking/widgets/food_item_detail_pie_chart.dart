import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

import 'package:fit_tip/food_tracking/blocs/blocs.dart';

import 'widgets.dart';

class FoodItemDetailPieChart extends StatelessWidget {
  const FoodItemDetailPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodItemDetailBloc, FoodItemDetailState>(
      builder: (context, state) {
        if (state.item.macronutrients == null) {
          return _Text(
            text: state.item.calories.toStringAsFixed(0),
          );
        }

        return CustomPaint(
          painter: FoodItemMacrosPieChartPainter(
            carbsAmount: state.item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.carbs).amount,
            fatAmount: state.item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.fat).amount,
            proteinAmount: state.item.macronutrients!.firstWhere((e) => e.macronutrient == Macronutrient.protein).amount,
          ),
          child: _Text(
            text: state.item.calories.toStringAsFixed(0),
          ),
        );
      },
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text + 'cal',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}

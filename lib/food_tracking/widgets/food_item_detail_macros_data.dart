import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class FoodItemMacrosData extends StatelessWidget {
  FoodItemMacrosData({Key? key}) : super(key: key);

  final inputDecorationStyle = InputDecoration(border: InputBorder.none);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodItemDetailBloc, FoodItemDetailState>(
      builder: (context, state) {
        if (state.item.macronutrients == null) return Container();

        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.item.macronutrients!.map((e) {
              return TextFormField(
                key: ValueKey(e.amount),
                initialValue: e.amount.toStringAsFixed(0) + 'g',
                enabled: false,
                decoration: inputDecorationStyle.copyWith(
                  labelText: macronutrientToString(e.macronutrient),
                  labelStyle: TextStyle(
                    color: mapMacronutrientToColor(e.macronutrient),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Color mapMacronutrientToColor(Macronutrient a) {
    if (a == Macronutrient.fat) {
      return Colors.red;
    } else if (a == Macronutrient.carbs) {
      return Colors.blue;
    } else if (a == Macronutrient.protein) {
      return Colors.green;
    }
    return Colors.grey;
  }
}

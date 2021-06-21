import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class MealTypeInput extends StatelessWidget {
  const MealTypeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return ListTile(
          title: Text('Meal: '),
          trailing: DropdownButton<MealType>(
            value: state.type,
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            items: MealType.values.map((e) {
              return DropdownMenuItem(
                child: Text(
                  mapMealTypeToString(e),
                ),
                value: e,
              );
            }).toList(),
            onChanged: (type) {
              BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemMealTypeChanged(value: type));
            },
          ),
        );
      },
    );
  }
}

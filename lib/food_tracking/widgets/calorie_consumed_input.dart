import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalorieConsumedInput extends StatelessWidget {
  const CalorieConsumedInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Calories',
            errorText: state.calorieConsumed.invalid ? 'Invalid' : null,
          ),
          onChanged: (val) => BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemCalorieChanged(value: val)),
        );
      },
    );
  }
}

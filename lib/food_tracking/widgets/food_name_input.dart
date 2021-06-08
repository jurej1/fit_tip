import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodNameInput extends StatelessWidget {
  const FoodNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.foodName.value,
          decoration: InputDecoration(
            helperText: 'Food name',
            errorText: state.foodName.invalid ? 'Invalid input' : null,
          ),
          onChanged: (val) => BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemNameChanged(name: val)),
        );
      },
    );
  }
}

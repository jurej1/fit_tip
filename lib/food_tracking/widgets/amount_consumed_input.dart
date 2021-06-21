import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmountConsumedInput extends StatelessWidget {
  const AmountConsumedInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return Row(
          children: [
            Text('Amount'),
            Expanded(
              child: TextFormField(
                initialValue: state.amountConsumed.value,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: state.amountConsumed.invalid ? 'Invalid' : null,
                ),
                onChanged: (val) => BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemAmountChanged(value: val)),
              ),
            ),
            Text('g'),
          ],
        );
      },
    );
  }
}

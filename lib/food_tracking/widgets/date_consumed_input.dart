import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateConsumedInput extends StatelessWidget {
  const DateConsumedInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return ListTile(
          title: Text('Date'),
          subtitle: state.dateConsumed.invalid ? Text('Invalid') : null,
          trailing: Text(DateFormat('dd.MMMM.yyyy').format(state.dateConsumed.value)),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: state.dateConsumed.value,
              firstDate: state.dateConsumed.value.subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );

            BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemDateChanged(date: date));
          },
        );
      },
    );
  }
}

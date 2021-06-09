import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeConsumedInput extends StatelessWidget {
  const TimeConsumedInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
      builder: (context, state) {
        return ListTile(
          title: Text('Time:'),
          trailing: Text(state.timeConsumed.value.format(context)),
          subtitle: state.timeConsumed.invalid ? Text('Invalid') : null,
          onTap: () async {
            TimeOfDay? time = await showTimePicker(context: context, initialTime: state.timeConsumed.value);

            BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemTimeConsumed(timeOfDay: time));
          },
        );
      },
    );
  }
}

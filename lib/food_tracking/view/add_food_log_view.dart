import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/food_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddFoodLogView extends StatelessWidget {
  const AddFoodLogView({Key? key}) : super(key: key);

  static const routeName = 'add_food_log_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add food log'),
      ),
      body: BlocBuilder<AddFoodItemBloc, AddFoodItemState>(
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }

          return ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              FoodNameInput(),
              DateConsumedInput(),
              TimeConsumedInput(),
              CalorieConsumedInput(),
              AmountConsumedInput(),
              MealTypeInput(),
            ],
          );
        },
      ),
    );
  }
}

import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

class EditCalorieDailyGoalView extends StatelessWidget {
  const EditCalorieDailyGoalView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final calorieDailyGoalBloc = BlocProvider.of<CalorieDailyGoalBloc>(context);
    final foodLogFocusedDate = BlocProvider.of<FoodLogFocusedDateBloc>(context);

    return MaterialPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => EditCalorieDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
                foodLogFocusedDateBloc: foodLogFocusedDate,
                calorieDailyGoalBloc: calorieDailyGoalBloc,
              ),
            ),
            BlocProvider.value(
              value: calorieDailyGoalBloc,
            ),
          ],
          child: EditCalorieDailyGoalView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<CalorieDailyGoalBloc>(context).add(CalorieDailyGoalUpdated(calorieDailyGoal: state.goal));
          Navigator.of(context).pop();
        }

        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Sorry there was an erro'),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit calorie daily goal'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalFormSubmit());
              },
            )
          ],
        ),
        body: BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
          builder: (context, state) {
            if (state.status.isSubmissionInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              padding: EdgeInsets.all(10),
              children: [
                CaloriesAmountInputField(),
                //Fats input
                //Carbs input
                //protein input
              ],
            );
          },
        ),
      ),
    );
  }
}

class CaloriesAmountInputField extends StatelessWidget {
  const CaloriesAmountInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return Row(
          children: [
            Text('Daily goal:'),
            Expanded(
              child: TextFormField(
                key: ValueKey(state.calorieGoalConsumption),
                initialValue: state.calorieGoalConsumption.value,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalAmountChanged(amount: val));
                },
              ),
            ),
            Text('cal'),
          ],
        );
      },
    );
  }
}

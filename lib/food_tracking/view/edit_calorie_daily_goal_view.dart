import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/shared/blocs/day_selector/day_selector_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

class EditCalorieDailyGoalView extends StatelessWidget {
  const EditCalorieDailyGoalView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    final calorieDailyGoalBloc = BlocProvider.of<CalorieDailyGoalBloc>(context);
    final daySelectorBloc = BlocProvider.of<DaySelectorBloc>(context);

    return MaterialPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => EditCalorieDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
                foodLogFocusedDateBloc: daySelectorBloc,
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
                FocusScope.of(context).unfocus();
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
                FatsAmountInput(),
                CarbsAmountInput(),
                ProteinAmountInput(),
                MealsTitle(
                  children: [
                    BreakfastInput(),
                    LunchInput(),
                    DinnerInput(),
                    SnackInput(),
                  ],
                ),
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
                  key: ValueKey(state.calorieDailyConsumptionGoal),
                  initialValue: state.calorieDailyConsumptionGoal.value,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: showErrorTest(state),
                  ),
                  onChanged: (val) {
                    BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalAmountChanged(val));
                  }),
            ),
            Text('cal'),
          ],
        );
      },
    );
  }

  String? showErrorTest(EditCalorieDailyGoalState state) {
    if (state.calorieDailyConsumptionGoal.invalid) {
      CalorieDailyConsumptionGoalValidationError? error = state.calorieDailyConsumptionGoal.error;

      if (error == CalorieDailyConsumptionGoalValidationError.invalid) {
        return 'Invalid';
      } else if (error == CalorieDailyConsumptionGoalValidationError.mealsContainsMoreCalories) {
        return 'Meals contain more calories';
      }
    }
    return null;
  }
}

class FatsAmountInput extends StatelessWidget {
  const FatsAmountInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.fats.value,
          onChanged: (val) => BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalFatsChanged(val)),
          title: 'Fats',
          unit: 'g',
          errorText: state.fats.invalid ? 'Invalid' : null,
          key: ValueKey(state.fats),
        );
      },
    );
  }
}

class ProteinAmountInput extends StatelessWidget {
  const ProteinAmountInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.proteins.value,
          onChanged: (val) => BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalProteinChanged(val)),
          title: 'Protein',
          unit: 'g',
          errorText: state.proteins.invalid ? 'Invalid' : null,
          key: ValueKey(state.proteins),
        );
      },
    );
  }
}

class CarbsAmountInput extends StatelessWidget {
  const CarbsAmountInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.carbs.value,
          onChanged: (val) => BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalCarbsChanged(val)),
          title: 'Carbs',
          unit: 'g',
          errorText: state.carbs.invalid ? 'Invalid' : null,
          key: ValueKey(state.carbs),
        );
      },
    );
  }
}

class BreakfastInput extends StatelessWidget {
  const BreakfastInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.breakfast.value,
          onChanged: (val) {
            BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalBreakfastChanged(val));
          },
          unit: 'cal',
          title: 'Breakfast',
        );
      },
    );
  }
}

class LunchInput extends StatelessWidget {
  const LunchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.lunch.value,
          onChanged: (val) {
            BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalLunchChanged(val));
          },
          unit: 'cal',
          title: 'Lunch',
        );
      },
    );
  }
}

class DinnerInput extends StatelessWidget {
  const DinnerInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.dinner.value,
          onChanged: (value) {
            BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalDinnerChanged(value));
          },
          unit: 'cal',
          title: 'Dinner',
        );
      },
    );
  }
}

class SnackInput extends StatelessWidget {
  const SnackInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCalorieDailyGoalBloc, EditCalorieDailyGoalState>(
      builder: (context, state) {
        return RowInputField(
          initialValue: state.snack.value,
          onChanged: (value) {
            BlocProvider.of<EditCalorieDailyGoalBloc>(context).add(EditCalorieDailyGoalSnackChanged(value));
          },
          unit: 'cal',
          title: 'Snack',
        );
      },
    );
  }
}

class MealsTitle extends StatelessWidget {
  const MealsTitle({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meals goals:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

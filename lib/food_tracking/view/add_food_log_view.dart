import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/blocs/food_item_detail/food_item_detail_bloc.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/food_tracking/widgets/widgets.dart';
import 'package:fit_tip/shared/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

class AddFoodLogView extends StatelessWidget {
  const AddFoodLogView({Key? key}) : super(key: key);

  static MaterialPageRoute route(
    BuildContext context, {
    FoodItemDetailBloc? fooditemDetailBloc,
  }) {
    DaySelectorBloc daySelectorBloc = BlocProvider.of<DaySelectorBloc>(context);

    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AddFoodItemBloc(
                focusedDate: daySelectorBloc,
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
                foodItem: fooditemDetailBloc?.state.item,
              ),
            ),
            BlocProvider<FoodDailyLogsBloc>.value(
              value: BlocProvider.of<FoodDailyLogsBloc>(context),
            ),
            if (fooditemDetailBloc != null)
              BlocProvider.value(
                value: fooditemDetailBloc,
              ),
          ],
          child: AddFoodLogView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFoodItemBloc, AddFoodItemState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          if (state.mode == AddFoodItemStateMode.add) {
            BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsLogAdded(foodItem: state.foodItem));
          }

          if (state.mode == AddFoodItemStateMode.edit) {
            BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsLogUpdated(foodItem: state.foodItem));
            BlocProvider.of<FoodItemDetailBloc>(context).add(FoodItemDetailUpdated(foodItem: state.foodItem));
          }
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error occured',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add food log'),
          actions: [
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                BlocProvider.of<AddFoodItemBloc>(context).add(AddFoodItemSubmitForm());
              },
            ),
          ],
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
                const FoodNameInput(),
                const DateConsumedInput(),
                const TimeConsumedInput(),
                const CalorieConsumedInput(),
                const AmountConsumedInput(),
                const MealTypeInput(),
                const DetailInputList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DetailInputList extends StatelessWidget {
  const DetailInputList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowExpandedInputListTile(),
        FoodItemDetailForm(),
      ],
    );
  }
}

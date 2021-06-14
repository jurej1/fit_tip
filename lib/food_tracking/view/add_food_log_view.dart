import 'dart:math';

import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:fit_tip/food_tracking/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';

class AddFoodLogView extends StatelessWidget {
  const AddFoodLogView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddFoodItemBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              foodRepository: RepositoryProvider.of<FoodRepository>(context),
            ),
          ),
          BlocProvider<FoodDailyLogsBloc>.value(
            value: BlocProvider.of<FoodDailyLogsBloc>(context),
          ),
        ],
        child: AddFoodLogView(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFoodItemBloc, AddFoodItemState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsLogAdded(foodItem: state.foodItem));
          Navigator.of(context).pop();
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
      ),
    );
  }
}

class DetailInputList extends StatefulWidget {
  const DetailInputList({Key? key}) : super(key: key);

  @override
  _DetailInputListState createState() => _DetailInputListState();
}

class _DetailInputListState extends State<DetailInputList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowExpandedInputListTile(),
      ],
    );
  }
}

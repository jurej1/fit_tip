import 'package:fit_tip/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/blocs/food_item_detail/food_item_detail_bloc.dart';
import 'package:fit_tip/food_tracking/food_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class FoodItemDetailView extends StatelessWidget {
  const FoodItemDetailView({Key? key}) : super(key: key);

  static MaterialPageRoute route(
    BuildContext context, {
    required FoodItem item,
    // required FoodDailyLogsBloc foodDailyLogsBloc,
  }) {
    return MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<FoodDailyLogsBloc>(context),
            ),
            BlocProvider(
              create: (context) => FoodItemDetailBloc(
                foodItem: item,
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
              ),
            ),
          ],
          child: FoodItemDetailView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodItemDetailBloc, FoodItemDetailState>(
      listener: (context, state) {
        if (state is FoodItemDetailDeleteSuccess) {
          BlocProvider.of<FoodDailyLogsBloc>(context).add(FoodDailyLogsLogRemoved(foodItem: state.item));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail view'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                BlocProvider.of<FoodItemDetailBloc>(context).add(FoodItemDetailDeleteRequested());
              },
            ),
            //EDITING FUNCTION
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  AddFoodLogView.route(
                    context,
                    fooditemDetailBloc: BlocProvider.of<FoodItemDetailBloc>(context),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            //Pie Chart with carbs, fats, and proteins
            // in the center of the pie char is going to be the amount of calories

            //NAME

            //Amount

            //DATE & TIME

            //VITAMINS
          ],
        ),
      ),
    );
  }
}

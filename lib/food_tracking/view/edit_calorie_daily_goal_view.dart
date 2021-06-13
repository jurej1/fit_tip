import 'package:fit_tip/authentication/authentication.dart';
import 'package:fit_tip/food_tracking/blocs/blocs.dart';
import 'package:fit_tip/food_tracking/blocs/edit_calorie_daily_goal/edit_calorie_daily_goal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';

class EditCalorieDailyGoalView extends StatelessWidget {
  const EditCalorieDailyGoalView({Key? key}) : super(key: key);

  static MaterialPageRoute route(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => EditCalorieDailyGoalBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                foodRepository: RepositoryProvider.of<FoodRepository>(context),
                foodLogFocusedDateBloc: BlocProvider.of<FoodLogFocusedDateBloc>(context),
              ),
            ),
            BlocProvider.value(
              value: BlocProvider.of<CalorieDailyGoalBloc>(context),
            ),
          ],
          child: EditCalorieDailyGoalView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit calorie daily goal'),
      ),
    );
  }
}
